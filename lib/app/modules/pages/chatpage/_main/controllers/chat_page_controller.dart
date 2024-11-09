import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Chat/chat_message.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class ChatPageController extends GetxController {
  final UserAccounts currentUserAccounts;
  ChatPageController({required this.currentUserAccounts});

  var chatPage = 1.obs;
  var chatsearchprocess = false.obs;
  var isFirstFetch = true.obs;
  var filteredItems = Rxn<List<Chat>>();
  var chatcontroller = TextEditingController().obs;
  var chatScrollController = ScrollController().obs;
  var searchStatus = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (isFirstFetch.value) {
      getchat();
    }

    chatcontroller.value.addListener(() {
      String newText = chatcontroller.value.text.toLowerCase();
      // Filtreleme işlemi
      filteredItems.value =
          currentUserAccounts.user.value.chatlist!.where((item) {
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
      currentUserAccounts.user.value.chatlist = [];
    }

    if (chatPage.value == 1 && !fetchRestart) {
      if (currentUserAccounts.user.value.chatlist != null) {
        filteredItems.value = currentUserAccounts.user.value.chatlist!;

        int pageCount =
            (currentUserAccounts.user.value.widgetStoriescard!.length / 30)
                .ceil();
        log(pageCount.toString());

        chatPage.value = pageCount;
        chatPage++;
      } else {
        currentUserAccounts.user.value.chatlist = [];
      }
    }

    chatsearchprocess.value = true;
    FunctionService f = FunctionService(
      currentUser: currentUserAccounts.user.value,
    );
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

      currentUserAccounts.user.value.chatlist!.add(
        Chat(
          chatID: 1,
          user: User(
            userID: response["icerik"][i]["kullid"],
            displayName: response["icerik"][i]["adisoyadi"],
            lastlogin: Rx<String>(response["icerik"][i]["songiris"]),
            lastloginv2: Rx<String>(response["icerik"][i]["songiris"]),
            avatar: Media(
              mediaID: response["icerik"][i]["kullid"],
              mediaURL: MediaURL(
                bigURL: Rx<String>(
                    response["icerik"][i]["chatImage"]["media_bigURL"]),
                normalURL:
                    Rx<String>(response["icerik"][i]["chatImage"]["media_URL"]),
                minURL: Rx<String>(
                    response["icerik"][i]["chatImage"]["media_minURL"]),
              ),
            ),
          ),
          lastmessage: ChatMessage(
            user: User(userID: 1, avatar: null, displayName: ""),
            messageContext: sonmesaj,
            messageID: 1,
            isMe: response["icerik"][i]["kullid"] ==
                    currentUserAccounts.user.value.userID
                ? true
                : false,
          ),
          chatType: response["icerik"][i]["sohbetturu"],
          chatNotification: notification,
        ),
      );
    }

    filteredItems.value = currentUserAccounts.user.value.chatlist!;

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
  Widget chatListWidget() {
    if (filteredItems.value == null) {
      return const CupertinoActivityIndicator();
    } else if (filteredItems.value!.isEmpty) {
      return !isFirstFetch.value && !chatsearchprocess.value
          ? const Center(
              child: Text("Sohbet Geçmişi Boş"),
            )
          : const CupertinoActivityIndicator();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: filteredItems.value!.length,
          itemBuilder: (BuildContext context, int index) {
            return buildChatListTile(context, index, currentUserAccounts);
          },
        ),
      );
    }
  }

  //Notes

  void notecreate() {
    var textcontroller = TextEditingController().obs;

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "Create Chat Note",
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Obx(
                      () => TextButton(
                        onPressed: textcontroller.value.text == ""
                            ? null
                            : () {
                                log("");
                              },
                        child: Text(
                          'Paylaş',
                          style: TextStyle(
                            color: textcontroller.value.text == ""
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    currentUserAccounts.user.value.avatar!
                                        .mediaURL.minURL.value,
                                  ),
                                ),
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Get.theme.cardColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        onChanged: (val) {
                                          textcontroller.refresh();
                                        },
                                        style: const TextStyle(fontSize: 12),
                                        textAlign: TextAlign.center,
                                        maxLines: 4,
                                        minLines: 1,
                                        controller: textcontroller.value,
                                        decoration: InputDecoration(
                                          hintText: 'Bir şarkı paylaş',
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Get.theme.primaryColor
                                                .withOpacity(0.5),
                                          ),

                                          border:
                                              InputBorder.none, // Kenarlık yok
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 0.0,
                                            horizontal: 0.0,
                                          ),
                                          // İçerik dolgusu
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -10,
                                    left: 6,
                                    child: Container(
                                      height: 9,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: Get.theme.cardColor,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -20,
                                    left: 12,
                                    child: Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                          color: Get.theme.cardColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Get.theme.highlightColor,
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.music_note_rounded),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Get.theme.highlightColor,
                                  ),
                                ),
                                onPressed: () {},
                                icon:
                                    const Icon(Icons.question_answer_outlined),
                              ),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Get.theme.highlightColor,
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.camera_alt_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.supervised_user_circle_sharp,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              const Text("Hedef Kitle:"),
                              const SizedBox(width: 2),
                              const Text("Herkes"),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Get.theme.primaryColor.withOpacity(0.8),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget chatmyfriendsNotes(User user) {
    var haveSong = false;
    var havetext = false;

    var isMe = false;
    if (user == currentUserAccounts.user.value) {
      isMe = true;
      havetext = false;
      haveSong = false;
    } else {
      havetext = true;
      haveSong = false;
    }

    var haveSomething = haveSong || havetext;

    return GestureDetector(
      onTap: () {
        notecreate();
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.transparent,
                    foregroundImage: CachedNetworkImageProvider(
                      user.avatar!.mediaURL.minURL.value,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3.0,
                  ),
                  child: SizedBox(
                    child: Text(
                      isMe ? "Notun" : user.displayName!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        color:
                            Get.theme.primaryColor.withOpacity(isMe ? 0.8 : 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: !haveSomething && !isMe
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              !haveSong
                                  ? Container()
                                  : Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 2.0,
                                          ),
                                          child: Icon(
                                            Icons.music_note,
                                            size: 10,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 15,
                                            child: Marquee(
                                              text: "Sevecek Sandım",
                                              velocity: 20.0,
                                              blankSpace: 10,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              !haveSong
                                  ? Container()
                                  : Text(
                                      "Semicenk",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.primaryColor
                                            .withOpacity(0.5),
                                      ),
                                    ),
                              !havetext
                                  ? !isMe
                                      ? Container()
                                      : Text(
                                          "bir şarkı paylaş",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Get.theme.primaryColor
                                                .withOpacity(0.8),
                                          ),
                                        )
                                  : Text(
                                      "Bozuk sütler midenizi, sütü bozuklar dengenizi bozar Hayırlı Cumalar",
                                      maxLines: !haveSong ? 4 : 2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                            ],
                          ),
                          Positioned(
                            bottom: -10,
                            left: 6,
                            child: Container(
                              height: 9,
                              width: 10,
                              decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: 12,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
