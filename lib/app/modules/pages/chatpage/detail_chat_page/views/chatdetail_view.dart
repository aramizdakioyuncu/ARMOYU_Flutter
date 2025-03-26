import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/modules/pages/chatpage/detail_chat_page/controllers/chatdetail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatdetailView extends StatelessWidget {
  const ChatdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatdetailController());

    return Scaffold(
      body: API.widgets.chat.chatdetailWidget(
        context,
        chat: controller.chat.value!,
        chatcall: (chat) {
          Get.toNamed("/chat/call", arguments: {"chat": chat});
        },
        onClose: () {
          Get.back();
        },
        onPressedtoProfile: (userID, username) {
          log(("$userID $username"));
        },
      ),
    );
  }
}
