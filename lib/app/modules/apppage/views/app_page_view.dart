import 'dart:developer';

import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPageView extends StatelessWidget {
  const AppPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppPageController());
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(
          () => PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.pagesController.value,
            onPageChanged: (index) {
              log("Şu anda geçilen sayfa: $index");
            },
            children: controller.pagesViewList,
          ),
        ),
      ),
    );
  }
}
