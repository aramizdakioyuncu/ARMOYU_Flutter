import 'dart:developer';
import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/_main/controllers/chat_page_controller.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/new_chat_page/views/chat_new_page.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final UserAccounts currentUserAccounts;

  const ChatPage({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  Widget build(BuildContext context) {
    final currentAccountController = Get.find<PagesController>(
      tag: currentUserAccounts.user.userID.toString(),
    );
    log("***-**${currentAccountController.currentUserAccounts.user.displayName}");

    final controller = Get.put(
      ChatPageController(
        currentUserAccounts: currentUserAccounts,
      ),
      tag: currentUserAccounts.user.userID.toString(),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => AppBar(
            leading: IconButton(
              onPressed: () {
                currentAccountController.changePage(0);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: controller.searchStatus.value
                ? Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: ARMOYU.bodyColor,
                    ),
                    child: TextField(
                      controller: controller.chatcontroller.value,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                        ),
                        hintText: 'Ara',
                      ),
                    ),
                  )
                : const Text("Sohbetler"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  controller.searchStatus.value =
                      !controller.searchStatus.value;
                },
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        //Allways olduğu zaman her zaman oluyor lakin androidde çalışmıyor
        physics: const BouncingScrollPhysics(),
        controller: controller.chatScrollController.value,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller.handleRefresh();
            },
          ),
          Obx(
            () => controller.chatListWidget(
              context,
              currentAccountController.currentUserAccounts,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag:
            "NewChatButton${currentAccountController.currentUserAccounts.user.userID}",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatNewPage(
                currentUserAccounts:
                    currentAccountController.currentUserAccounts,
              ),
            ),
          );
        },
        backgroundColor: ARMOYU.buttonColor,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }
}
