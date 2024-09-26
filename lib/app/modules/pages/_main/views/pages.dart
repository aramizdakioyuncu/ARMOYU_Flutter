// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/views/main_view.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/_main/views/chat_page.dart';
import 'package:get/get.dart';

class Pages extends StatelessWidget {
  final UserAccounts currentUserAccounts;
  const Pages({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  Widget build(BuildContext context) {
    log("***1**${currentUserAccounts.user.displayName}**1***");

    final controller = Get.put(
      PagesController(
        currentUserAccounts: currentUserAccounts,
      ),
      tag: currentUserAccounts.user.userID.toString(),
    );

    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında yapılacak işlemler
        controller.changePage(0);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MainPageView(
              currentUserAccounts: currentUserAccounts,
            ),
            ChatPage(
              currentUserAccounts: currentUserAccounts,
            ),
          ],
        ),
      ),
    );
  }
}
