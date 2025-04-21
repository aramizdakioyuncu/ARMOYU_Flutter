import 'dart:developer';
import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/modules/pages/chatpage/_main/controllers/chat_controller.dart';
import 'package:armoyu/app/modules/pages/chatpage/new_chat_page/views/chat_new_page.dart';
import 'package:armoyu/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    //Controller Çek
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");

    final currentAccountController = Get.find<PagesController>(
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );

    final controller = Get.put(
      ChatController(),
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => AppBar(
            forceMaterialTransparency: true,
            leading: IconButton(
              onPressed: () {
                currentAccountController.changePage(0);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: controller.searchStatus.value
                ? SizedBox(
                    height: 45,
                    child: TextField(
                      controller: controller.chatcontroller.value,
                      onChanged: (value) =>
                          controller.widgetChat.filterList(value),
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: CommonKeys.search.tr,
                      ),
                    ),
                  )
                : Text(ChatKeys.chat.tr),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  controller.searchStatus.value =
                      !controller.searchStatus.value;
                  if (!controller.searchStatus.value) {
                    controller.chatcontroller.value.text = "";
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        controller: controller.chatScrollController.value,
        children: [
          API.widgets.chat.chatmyfriendsNotes(context),
          controller.widgetChat.widget.value!,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag:
            "NewChatButton${currentAccountController.currentUserAccount.user.value.userID}",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatNewPage(
                currentUserAccounts:
                    currentAccountController.currentUserAccount,
              ),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
