import 'dart:developer';
import 'package:armoyu/app/modules/pages/chatpage/_main/views/chat_view.dart';
import 'package:armoyu/app/modules/pages/mainpage/_main/views/main_view.dart';
import 'package:armoyu/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PagesView extends StatelessWidget {
  const PagesView({super.key});

  @override
  Widget build(BuildContext context) {
    //Controller Çek
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    final controller = Get.put(
      PagesController(),
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
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
          children: const [
            MainView(),
            ChatView(),
          ],
        ),
      ),
    );
  }
}
