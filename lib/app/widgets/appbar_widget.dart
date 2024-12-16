import 'dart:developer';

import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AppbarWidget {
  static custom() {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    final controller = Get.find<MainPageController>(
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(
        () => Visibility(
          visible: controller.isBottomNavbarVisible.value,
          child: AppBar(
            forceMaterialTransparency: true,
            leading: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    controller.openDrawer();
                  },
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: controller.currentUserAccounts.value!.user.value
                                    .avatar ==
                                null
                            ? Shimmer.fromColors(
                                baseColor: Get.theme.disabledColor,
                                highlightColor: Get.theme.highlightColor,
                                child: const CircleAvatar(),
                              )
                            : CachedNetworkImage(
                                imageUrl: controller.currentUserAccounts.value!
                                    .user.value.avatar!.mediaURL.minURL.value,
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
            title: Visibility(
              visible: controller.appbarSearch.value,
              child: Container(
                // height: 50,
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: controller.appbarSearchTextController.value,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                    ),
                    hintText: CommonKeys.search.tr,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            actions: [
              Obx(
                () => IconButton(
                  icon: Badge(
                    isLabelVisible: controller.currentUserAccounts.value!
                                .chatNotificationCount.value !=
                            0
                        ? true
                        : false,
                    label: Text(
                      controller.currentUserAccounts.value!
                          .chatNotificationCount.value
                          .toString(),
                    ),
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    child: const Icon(
                      Icons.chat_bubble_rounded,
                    ),
                  ),
                  onPressed: () {
                    controller.changePageFunction(1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
