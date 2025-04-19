import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/chat/bundle/chat_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatNewController extends GetxController {
  var newchatList = <Chat>[].obs;

  var filteredItems = Rxn<List<User>>();

  var newchatcontroller = TextEditingController().obs;

  var chatScrollController = ScrollController().obs;

  late var currentUser = Rxn<User>();

  late ChatWidgetBundle widgetnewChat;

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    chatScrollController.value.addListener(() {
      if (chatScrollController.value.position.pixels >=
          chatScrollController.value.position.maxScrollExtent * 0.8) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        widgetnewChat.loadMore();
      }
    });

    widgetnewChat = API.widgets.chat.newchatListWidget(
      Get.context!,
      onPressed: (chat) {
        Get.toNamed("/chat/detail", arguments: {
          "chat": chat,
        });
      },
    );
  }
}
