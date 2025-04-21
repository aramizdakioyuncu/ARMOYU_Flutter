import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/chat/bundle/chat_bundle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class ChatController extends GetxController {
  var chatPage = 1.obs;
  var chatsearchprocess = false.obs;
  var isFirstFetch = true.obs;
  var filteredItems = Rxn<List<Chat>>();
  var chatcontroller = TextEditingController().obs;
  var chatScrollController = ScrollController().obs;
  var searchStatus = false.obs;
  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  late ChatWidgetBundle widgetChat;
  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts = findCurrentAccountController.currentUserAccounts;

    widgetChat = API.widgets.chat.chatListWidget(
      Get.context!,
      cachedChatList: currentUserAccounts.value.chatList,
      onChatUpdated: (updatedChat) {
        currentUserAccounts.value.chatList = updatedChat;
      },
      onPressed: (chat) {
        Get.toNamed(
          "/chat/detail",
          arguments: {"chat": chat},
        );
      },
    );

    chatScrollController.value.addListener(() {
      if (chatScrollController.value.position.pixels >=
          chatScrollController.value.position.maxScrollExtent * 0.8) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        widgetChat.loadMore();
      }
    });
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
                          CommonKeys.share.tr,
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
                                    currentUserAccounts.value.user.value.avatar!
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
                                          hintText: ChatKeys.chatshareasong.tr,
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            color: Get.theme.primaryColor
                                                .withValues(alpha: 0.5),
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
                              Text(ChatKeys.chatTargetAudience.tr),
                              const SizedBox(width: 2),
                              Text(CommonKeys.everyone.tr),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Get.theme.primaryColor
                                    .withValues(alpha: 0.8),
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

    if (user.userID == currentUserAccounts.value.user.value.userID) {
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
        isMe ? notecreate() : null;
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
                      isMe ? ChatKeys.chatyournote.tr : user.displayName!.value,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        color: Get.theme.primaryColor
                            .withValues(alpha: isMe ? 0.8 : 1),
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
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                              !havetext
                                  ? !isMe
                                      ? Container()
                                      : Text(
                                          ChatKeys.chatshareasong.tr,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Get.theme.primaryColor
                                                .withValues(alpha: 0.8),
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
