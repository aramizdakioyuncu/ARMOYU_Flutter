import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Chat/chat_message.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/services/Socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatdetailController extends GetxController {
  var messageController = TextEditingController().obs;
  var scrollController = ScrollController().obs;

  Rxn<Isolate> isolateListen = Rxn<Isolate>();
  Rxn<ReceivePort> receiveportListen = Rxn<ReceivePort>();

  Rxn<Isolate> isolateSend = Rxn<Isolate>();
  Rxn<ReceivePort> receiveportSend = Rxn<ReceivePort>();

  var isUserOnline = false.obs;

  late Rxn<Chat> chat = Rxn<Chat>();
  late Rxn<UserAccounts> currentUserAccounts = Rxn<UserAccounts>();

  @override
  void onInit() {
    super.onInit();

    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;

    UserAccounts currentUser = arguments['CurrentUserAccounts'];
    final currentAccountController = Get.find<PagesController>(
      tag: currentUser.user.userID.toString(),
    );

    log("*****${currentAccountController.currentUserAccounts.user.displayName}");

    /////
    currentUserAccounts.value = currentAccountController.currentUserAccounts;
    /////

    if (arguments['chat'] != null) {
      chat.value = arguments['chat'];
    }

    chat.value!.chatNotification = false;
    chat.value!.messages ??= [];
    if (chat.value!.messages!.isEmpty) {
      getchat().then((_) {
        isolatestart();
      });
    } else {
      isolatestart();
    }
  }

  @override
  void dispose() {
    super.dispose();

    // try {
    //   receiveportListen.close();
    //   isolateListen.value!.kill();

    //   receiveportSend.close();
    //   isolateSend.value!.kill();
    // } catch (e) {
    //   log(e.toString());
    // }

    try {
      receiveportListen.close();
      isolateListen.value?.kill();
      receiveportSend.close();
      isolateSend.value?.kill();
    } catch (e) {
      log("Dispose Error: $e");
    }
  }

  void isolatestart() async {
    receiveportListen.value = ReceivePort();

    receiveportSend.value = ReceivePort();

    isolateListen.value = await Isolate.spawn(socketListenMessage, [
      receiveportListen.value!.sendPort,
      currentUserAccounts.value!.user,
      chat.value!.user.userID.toString()
    ]);

    receiveportListen.value!.listen((message) async {
      try {
        var jsonData = jsonDecode(utf8.decode(message.codeUnits));

        Map<String, dynamic> responseData = jsonData;

        if (responseData["sender_id"].toString() ==
            currentUserAccounts.value!.user.userID.toString()) {
          return;
        }

        if (responseData["receiver_id"].toString() ==
            currentUserAccounts.value!.user.userID.toString()) {
          message = responseData["message"].toString();
        }
        chat.value!.messages!.add(
          ChatMessage(
            messageID: 0,
            isMe: false,
            messageContext: message,
            user: chat.value!.user,
          ),
        );
        chat.refresh();

        //SonMesajı güncelle
        chat.value!.lastmessage = ChatMessage(
          messageID: 0,
          isMe: false,
          messageContext: message,
          user: chat.value!.user,
        );

        log(message);
      } catch (e) {
        log("json hatası");
      }
    });

    ARMOYU_Socket socket2 = ARMOYU_Socket(
        currentUserAccounts.value!.user.userID.toString(),
        currentUserAccounts.value!.user.userName!,
        currentUserAccounts.value!.user.password!,
        chat.value!.user.userID.toString());

    receiveportSend.value!.listen(
      (message) {
        log("Send: $message");
        if (message != "") {
          socket2.sendMessage(receiveportListen.value!.sendPort, message);
        }
      },
    );
  }

  static Future<void> socketListenMessage(List<dynamic> arguments) async {
    final SendPort sendPort = arguments.first;
    final User user = arguments[1];
    final String receiverID = arguments.last;
    log("${user.userID} >>>> $receiverID");

    try {
      ARMOYU_Socket socket2 = ARMOYU_Socket(
        user.userID.toString(),
        user.userName!,
        user.password!,
        receiverID,
      );
      socket2.receiveMessages(sendPort);

      log("asd");
    } catch (e) {
      log(e.toString());
      log("asd!!!");
    }
  }

  Future<void> getchat() async {
    FunctionService f =
        FunctionService(currentUser: currentUserAccounts.value!.user);
    Map<String, dynamic> response =
        await f.getdeailchats(chat.value!.user.userID!);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
      return;
    }

    log("------");

    var ismee = true.obs;
    // if (mounted) {
    chat.value!.messages = [];
    // }

    log(response["icerik"].length.toString());

    log(chat.value!.messages!.length.toString());
    for (dynamic element in response["icerik"]) {
      try {
        if (element["sohbetkim"] == "ben") {
          ismee.value = true;
        } else {
          ismee.value = false;
        }

        chat.value!.messages!.add(
          ChatMessage(
            messageID: 0,
            isMe: ismee.value,
            messageContext: element["mesajicerik"],
            user: chat.value!.user,
          ),
        );
        chat.refresh();
        //SonMesajı güncelle
        chat.value!.lastmessage = ChatMessage(
          messageID: 0,
          isMe: ismee.value,
          messageContext: element["mesajicerik"],
          user: chat.value!.user,
        );
      } catch (e) {
        log("Sohbet getirilemedi! : $e");
      }
    }
  }

  sendMessage() async {
    if (messageController.value.text == "") {
      return;
    }
    String message = messageController.value.text;
    messageController.value.text = "";
    chat.value!.messages!.add(
      ChatMessage(
        messageID: 0,
        isMe: true,
        messageContext: message,
        user: currentUserAccounts.value!.user,
      ),
    );
    chat.refresh();

    //SonMesajı güncelle
    chat.value!.lastmessage = ChatMessage(
      messageID: 0,
      isMe: true,
      messageContext: message,
      user: currentUserAccounts.value!.user,
    );

    FunctionService f = FunctionService(
      currentUser: currentUserAccounts.value!.user,
    );
    Map<String, dynamic> response =
        await f.sendchatmessage(chat.value!.user.userID!, message, "ozel");
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    receiveportSend.value!.sendPort.send(message);
  }

  // ListView.builder yapısını burada tanımlıyoruz
  Widget chatListView(BuildContext context) {
    return chat.value?.messages == null
        ? Container()
        : ListView.builder(
            reverse: true,
            controller: scrollController.value,
            itemCount: chat.value!.messages!.length,
            itemBuilder: (context, index) {
              return chat
                  .value!.messages![chat.value!.messages!.length - 1 - index]
                  .messageBumble(context);
            },
          );
  }
}
