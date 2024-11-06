import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/new_chat_page/controllers/chat_new_controller.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatNewPage extends StatelessWidget {
  final UserAccounts currentUserAccounts;

  const ChatNewPage({
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
      ChatNewController(
        currentUserAccounts: currentAccountController.currentUserAccounts,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Sohbet"),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.chatScrollController.value,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async =>
                await controller.getchatfriendlist(fecthRestart: true),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ARMOYU.bodyColor,
                ),
                child: TextField(
                  controller: controller.newchatcontroller.value,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    hintText: 'Ara',
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.filteredItems.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text("Oops! Bulunamadı!😂")))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: controller.filteredItems.length,
                      (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundImage: CachedNetworkImageProvider(
                                  controller.filteredItems[index].avatar!
                                      .mediaURL.minURL.value,
                                ),
                              ),
                              title: CustomText.costum1(
                                  controller.filteredItems[index].displayName!),
                              trailing: Text(controller
                                  .filteredItems[index].lastloginv2
                                  .toString()),
                              onTap: () {
                                Get.toNamed("/chat/detail", arguments: {
                                  "chat": Chat(
                                    user: controller.filteredItems[index],
                                    chatNotification: false,
                                  ),
                                  "CurrentUserAccounts": currentUserAccounts,
                                });
                              },
                            ),
                            const SizedBox(height: 1),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
