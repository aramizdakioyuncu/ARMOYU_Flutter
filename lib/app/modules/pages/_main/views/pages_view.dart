import 'dart:developer';

import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/views/main_view.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/_main/views/chat_page.dart';
import 'package:get/get.dart';

class PagesView extends StatelessWidget {
  final UserAccounts currentUserAccounts;
  const PagesView({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  Widget build(BuildContext context) {
    log("*****${currentUserAccounts.user.value.displayName}*****");

    //Controller Çek
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    final controller = Get.put(
      PagesController(currentUserAccounts: currentUserAccounts),
      tag: currentUserAccounts.user.value.userID.toString(),
    );

    // ignore: deprecated_member_use
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
            const MainView(),
            ChatPage(
              currentUserAccounts: currentUserAccounts,
            ),
          ],
        ),
      ),
    );
  }
}
