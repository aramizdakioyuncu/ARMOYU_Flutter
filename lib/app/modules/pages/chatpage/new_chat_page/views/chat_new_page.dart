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
      body: ListView(
        controller: controller.chatScrollController.value,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => controller.widgetnewChat.filterList(value),
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: CommonKeys.search.tr,
              ),
            ),
          ),
          controller.widgetnewChat.widget.value!,
        ],
      ),
    );
  }
}
