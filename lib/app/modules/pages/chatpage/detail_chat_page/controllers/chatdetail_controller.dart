import 'dart:developer';

import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Chat/chat_message.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/services/socketio_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat_detail_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatdetailController extends GetxController {
  var messageController = TextEditingController().obs;
  var scrollController = ScrollController().obs;

  var isUserOnline = false.obs;

  late Rxn<Chat> chat = Rxn<Chat>();
  late Rxn<UserAccounts> currentUserAccounts = Rxn<UserAccounts>();
  //Socket Güncelle
  var socketio = Get.find<SocketioController>();
  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");

    /////
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    /////

    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;
    if (arguments['chat'] != null) {
      chat.value = arguments['chat'];
    }

    final chatList = currentUserAccounts.value!.chatList!;
    final targetUserID = chat.value!.user.userID;

    // Var olan sohbeti bul
    Chat? existingChat = chatList.firstWhereOrNull(
      (chatItem) => chatItem.user.userID == targetUserID,
    );

    // Yoksa ekle
    if (existingChat == null) {
      Future.microtask(() => chatList.add(chat.value!));
      existingChat = chat.value!;
      Future.microtask(() => currentUserAccounts.value!.chatList!.refresh());
    }

    // Güncel sohbeti ayarla
    chat.value = existingChat;

    chat.value!.messages ??= <ChatMessage>[].obs;
    if (chat.value!.messages!.isEmpty) {
      getchat().then((_) {});
    }
  }

  @override
  void dispose() {
    super.dispose();

    try {} catch (e) {
      log("Dispose Error: $e");
    }
  }

  Future<void> getchat() async {
    FunctionService f = FunctionService();
    ChatFetchDetailResponse response =
        await f.getdeailchats(chat.value!.user.userID!);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    if (response.response!.isEmpty) {
      return;
    }

    var ismee = true.obs;
    chat.value!.messages!.value = <ChatMessage>[].obs;

    for (APIChatDetailList element in response.response!) {
      try {
        if (element.sohbetKim == "ben") {
          ismee.value = true;
        } else {
          ismee.value = false;
        }

        chat.value!.messages!.add(
          ChatMessage(
            messageID: 0,
            isMe: ismee.value,
            messageContext: element.mesajIcerik,
            user: User(
              userID: chat.value!.user.userID,
              avatar: chat.value!.user.avatar,
              displayName: chat.value!.user.displayName,
            ),
          ),
        );
        chat.refresh();
        //SonMesajı güncelle
        chat.value!.lastmessage!.value = ChatMessage(
          messageID: 0,
          isMe: ismee.value,
          messageContext: element.mesajIcerik,
          user: User(
            userID: chat.value!.user.userID,
            avatar: chat.value!.user.avatar,
            displayName: chat.value!.user.displayName,
          ),
        );
      } catch (e) {
        log("Sohbet getirilemedi! : $e");
      }
    }
  }

  sendMessage() async {
    String message = messageController.value.text;

    if (messageController.value.text == "") {
      return;
    }

    messageController.value.text = "";
    chat.value!.messages!.add(
      ChatMessage(
        messageID: 0,
        isMe: true,
        messageContext: message,
        user: User(
          userID: currentUserAccounts.value!.user.value.userID,
          avatar: currentUserAccounts.value!.user.value.avatar,
          displayName: currentUserAccounts.value!.user.value.displayName,
        ),
      ),
    );

    // // //Son Mesajı güncelle
    chat.value!.lastmessage = ChatMessage(
      messageID: 0,
      isMe: true,
      messageContext: message,
      user: User(
        userID: currentUserAccounts.value!.user.value.userID,
        avatar: currentUserAccounts.value!.user.value.avatar,
        displayName: currentUserAccounts.value!.user.value.displayName,
      ),
    ).obs;

    socketio.sendMessage(
      ChatMessage(
        messageID: 0,
        isMe: true,
        messageContext: message,
        user: User(
          userID: currentUserAccounts.value!.user.value.userID,
          avatar: currentUserAccounts.value!.user.value.avatar,
          displayName: currentUserAccounts.value!.user.value.displayName,
        ),
      ),
      chat.value!.user.userID,
    );

    currentUserAccounts.value!.chatList!.refresh();
    FunctionService f = FunctionService();
    ServiceResult response =
        await f.sendchatmessage(chat.value!.user.userID!, message, "ozel");
    if (!response.status) {
      log(response.description);
      return;
    }
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
