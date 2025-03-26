import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/chatpage/new_chat_page/controllers/chat_new_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';

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
    final controller = Get.put(ChatNewController());
    return Scaffold(
      appBar: AppBar(
        title: Text(ChatKeys.chatnewchat.tr),
        forceMaterialTransparency: true,
      ),

      body: API.widgets.chat.newchatListWidget(
        context,
        scrollController: controller.chatScrollController.value,
        onPressed: (chat) {
          Get.toNamed("/chat/detail", arguments: {
            "chat": chat,
          });
        },
      ),
      // body: CustomScrollView(
      //   physics: const BouncingScrollPhysics(),
      //   controller: controller.chatScrollController.value,
      //   slivers: [
      //     CupertinoSliverRefreshControl(
      //       onRefresh: () async =>
      //           await controller.getchatfriendlist(fecthRestart: true),
      //     ),
      //     SliverToBoxAdapter(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: SizedBox(
      //           child: CustomTextfields.costum3(
      //             controller: controller.newchatcontroller,
      //             placeholder: CommonKeys.search.tr,
      //             preicon: const Icon(
      //               Icons.search,
      //               size: 20,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     Obx(
      //       () => controller.filteredItems.value == null
      //           ? const SliverFillRemaining(
      //               child: Center(
      //                 child: CupertinoActivityIndicator(),
      //               ),
      //             )
      //           : controller.filteredItems.value!.isEmpty
      //               ? SliverFillRemaining(
      //                   child: Center(
      //                     child: Text(CommonKeys.empty.tr),
      //                   ),
      //                 )
      //               : SliverList(
      //                   delegate: SliverChildBuilderDelegate(
      //                     childCount: controller.filteredItems.value!.length,
      //                     (context, index) {
      //                       return Column(
      //                         children: [
      //                           ListTile(
      //                             leading: CircleAvatar(
      //                               backgroundColor: Colors.transparent,
      //                               foregroundImage: CachedNetworkImageProvider(
      //                                 controller.filteredItems.value![index]
      //                                     .avatar!.mediaURL.minURL.value,
      //                               ),
      //                             ),
      //                             title: CustomText.costum1(
      //                               controller.filteredItems.value![index]
      //                                   .displayName!.value,
      //                             ),
      //                             trailing: Text(controller
      //                                 .filteredItems.value![index].lastloginv2
      //                                 .toString()
      //                                 .replaceAll(
      //                                     'Saniye', CommonKeys.second.tr)
      //                                 .replaceAll(
      //                                     'Dakika', CommonKeys.minute.tr)
      //                                 .replaceAll('Saat', CommonKeys.hour.tr)
      //                                 .replaceAll('Gün', CommonKeys.day.tr)
      //                                 .replaceAll('Ay', CommonKeys.month.tr)
      //                                 .replaceAll('Yıl', CommonKeys.year.tr)
      //                                 .replaceAll(
      //                                     'Çevrimiçi', CommonKeys.online.tr)
      //                                 .replaceAll(
      //                                     'Çevrimdışı', CommonKeys.offline.tr)),
      //                             onTap: () {
      //                               Get.toNamed("/chat/detail", arguments: {
      //                                 "chat": Chat(
      //                                   user: controller
      //                                       .filteredItems.value![index],
      //                                   chatNotification: false.obs,
      //                                 )
      //                               });
      //                             },
      //                           ),
      //                           const SizedBox(height: 1),
      //                         ],
      //                       );
      //                     },
      //                   ),
      //                 ),
      //     ),
      // ],
      // ),
    );
  }
}
