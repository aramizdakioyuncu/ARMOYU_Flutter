import 'dart:developer';
import 'package:ARMOYU/app/modules/pages/chatpage/_main/controllers/chat_page_controller.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/new_chat_page/views/chat_new_page.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
      ChatPageController(),
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
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
                ? SizedBox(
                    height: 45,
                    child: TextField(
                      controller: controller.chatcontroller.value,
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.chatScrollController.value,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller.handleRefresh();
            },
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                  children: [
                    controller.chatmyfriendsNotes(
                      findCurrentAccountController
                          .currentUserAccounts.value.user.value,
                    ),
                    ...List.generate(
                      findCurrentAccountController.currentUserAccounts.value
                                  .user.value.myFriends ==
                              null
                          ? 0
                          : findCurrentAccountController.currentUserAccounts
                              .value.user.value.myFriends!.length,
                      (index) {
                        return controller.chatmyfriendsNotes(
                          findCurrentAccountController.currentUserAccounts.value
                              .user.value.myFriends![index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => controller.filteredItems.value == null
                ? const SliverFillRemaining(
                    child: CupertinoActivityIndicator(),
                  )
                : controller.filteredItems.value!.isEmpty
                    ? SliverFillRemaining(
                        child: !controller.isFirstFetch.value &&
                                !controller.chatsearchprocess.value
                            ? Center(
                                child: Text(CommonKeys.empty.tr),
                              )
                            : const CupertinoActivityIndicator(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: controller.filteredItems.value!.length,
                          (context, index) {
                            return Obx(
                              () => controller.filteredItems.value![index]
                                  .listtilechat(
                                context,
                                currentUserAccounts:
                                    findCurrentAccountController
                                        .currentUserAccounts.value,
                              ),
                            );
                          },
                        ),
                      ),
          ),
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
