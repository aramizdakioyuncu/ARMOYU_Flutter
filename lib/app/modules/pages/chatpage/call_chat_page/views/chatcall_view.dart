import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/call_chat_page/controllers/chatcall_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatcallView extends StatelessWidget {
  const ChatcallView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatcallController());

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: API.widgets.chat.chatcallWidget(
        context,
        chat: controller.chat.value!,
        onClose: (chat) {
          Get.back();
        },
        speaker: (value) {},
        videocall: (value) {},
      ),
    );
  }
}
