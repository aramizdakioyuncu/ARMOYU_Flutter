import 'dart:developer';

import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/new_chat_page/controllers/chat_new_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
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
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    final controller = Get.put(
      ChatNewController(
        currentUserAccounts:
            findCurrentAccountController.currentUserAccounts.value,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(ChatKeys.chatnewchat.tr),
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
              child: SizedBox(
                child: CustomTextfields.costum3(
                  controller: controller.newchatcontroller,
                  placeholder: CommonKeys.search.tr,
                  preicon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.filteredItems.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                      child: Text("Oops! Bulunamadı!😂"),
                    ),
                  )
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
