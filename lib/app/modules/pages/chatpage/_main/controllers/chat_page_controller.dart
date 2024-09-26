import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Chat/chat_message.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatPageController extends GetxController {
  final UserAccounts currentUserAccounts;
  ChatPageController({required this.currentUserAccounts});

  var chatPage = 1.obs;
  var chatsearchprocess = false.obs;
  var isFirstFetch = true.obs;
  var filteredItems = Rxn<List<Chat>>();

  var searchStatus = false.obs;

  var chatcontroller = TextEditingController().obs;

  var chatScrollController = ScrollController().obs;

  @override
  void onInit() {
    super.onInit();

    if (isFirstFetch.value) {
      getchat();
    }

    chatcontroller.value.addListener(() {
      String newText = chatcontroller.value.text.toLowerCase();
      // Filtreleme işlemi
      filteredItems.value = currentUserAccounts.user.chatlist!.where((item) {
        return item.user.displayName!.toLowerCase().contains(newText);
      }).toList();
    });

    chatScrollController.value.addListener(() {
      if (chatScrollController.value.position.pixels >=
          chatScrollController.value.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getchat();
      }
    });
  }

  Future<void> handleRefresh() async {
    await getchat(fetchRestart: true);
  }

  Future<void> getchat({bool fetchRestart = false}) async {
    if (chatsearchprocess.value) {
      return;
    }

    if (fetchRestart) {
      chatPage.value = 1;
      currentUserAccounts.user.chatlist = [];
    }

    if (chatPage.value == 1 && !fetchRestart) {
      if (currentUserAccounts.user.chatlist != null) {
        filteredItems.value = currentUserAccounts.user.chatlist!;

        int pageCount =
            (currentUserAccounts.user.widgetStoriescard!.length / 30).ceil();
        log(pageCount.toString());

        chatPage.value = pageCount;
        chatPage++;
      } else {
        currentUserAccounts.user.chatlist = [];
      }
    }

    chatsearchprocess.value = true;
    FunctionService f = FunctionService(currentUser: currentUserAccounts.user);
    Map<String, dynamic> response = await f.getchats(chatPage.value);
    if (response["durum"] == 0) {
      chatsearchprocess.value = false;
      isFirstFetch.value = false;

      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      await getchat();
      return;
    }

    if (response["icerik"].length == 0) {
      chatsearchprocess.value = false;
      isFirstFetch.value = false;

      log("Sohbet Liste Sonu!");

      return;
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      String sonmesaj = response["icerik"][i]["sonmesaj"].toString();
      if (sonmesaj == "null") {
        sonmesaj = "";
      }
      bool notification = false;
      if (response["icerik"][i]["bildirim"] == 1) {
        notification = true;
      }

      currentUserAccounts.user.chatlist!.add(
        Chat(
          chatID: 1,
          user: User(
            userID: response["icerik"][i]["kullid"],
            displayName: response["icerik"][i]["adisoyadi"],
            lastlogin: response["icerik"][i]["songiris"],
            lastloginv2: response["icerik"][i]["songiris"],
            avatar: Media(
              mediaID: response["icerik"][i]["kullid"],
              mediaURL: MediaURL(
                bigURL: response["icerik"][i]["chatImage"]["media_bigURL"],
                normalURL: response["icerik"][i]["chatImage"]["media_URL"],
                minURL: response["icerik"][i]["chatImage"]["media_minURL"],
              ),
            ),
          ),
          lastmessage: ChatMessage(
            user: User(userID: 1, avatar: null, displayName: ""),
            messageContext: sonmesaj,
            messageID: 1,
            isMe: response["icerik"][i]["kullid"] ==
                    currentUserAccounts.user.userID
                ? true
                : false,
          ),
          chatType: response["icerik"][i]["sohbetturu"],
          chatNotification: notification,
        ),
      );
    }

    filteredItems.value = currentUserAccounts.user.chatlist!;

    chatsearchprocess.value = false;
    isFirstFetch.value = false;
    chatPage++;
  }

  // ListView.builder'da kullanılacak list item'ını dönen metod
  Widget buildChatListTile(
      BuildContext context, int index, UserAccounts currentUserAccounts) {
    final item = filteredItems.value![index];
    return item.listtilechat(context, currentUserAccounts: currentUserAccounts);
  }

  // Listeyi döndüren widget (ListView.builder)
  Widget chatListWidget(
      BuildContext context, UserAccounts currentUserAccounts) {
    if (filteredItems.value == null) {
      return const SliverFillRemaining(child: CupertinoActivityIndicator());
    } else if (filteredItems.value!.isEmpty) {
      return !isFirstFetch.value && !chatsearchprocess.value
          ? const SliverFillRemaining(child: Text("Sohbet geçmişi boş"))
          : const SliverFillRemaining(child: CupertinoActivityIndicator());
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return buildChatListTile(context, index, currentUserAccounts);
          },
          childCount: filteredItems.value!.length,
        ),
      );
    }
  }
}
