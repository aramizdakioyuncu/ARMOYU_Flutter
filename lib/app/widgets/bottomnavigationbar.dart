import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomnavigationBar {
  static Widget custom1() {
    final findCurrentAccountController = Get.find<AccountUserController>();

    final pagesController = Get.find<MainPageController>(
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );

    return Obx(
      () => BottomNavigationBar(
        onTap: (value) {
          pagesController.changePage(value);
        },
        currentIndex: pagesController.currentPage.value,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Arama',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: (pagesController
                          .currentUserAccounts.value!.groupInviteCount.value +
                      pagesController.currentUserAccounts.value!
                          .friendRequestCount.value) >
                  0,
              label: Text(
                (pagesController
                            .currentUserAccounts.value!.groupInviteCount.value +
                        pagesController.currentUserAccounts.value!
                            .friendRequestCount.value)
                    .toString(),
              ),
              textColor: Colors.white,
              backgroundColor: Colors.red,
              child: const Icon(
                Icons.notifications,
              ),
            ),
            label: 'Bildirimler',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onLongPress: () {
                // return;
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  isScrollControlled: true,
                  backgroundColor: Get.theme.scaffoldBackgroundColor,
                  context: Get.context!,
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                      heightFactor: 0.3,
                      child: Scaffold(
                        body: SingleChildScrollView(
                          child: SafeArea(
                            child: Column(
                              children: [
                                ...List.generate(ARMOYU.appUsers.length,
                                    (index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      foregroundImage:
                                          CachedNetworkImageProvider(
                                        ARMOYU.appUsers[index].user.value
                                            .avatar!.mediaURL.minURL.value,
                                      ),
                                    ),
                                    title: CustomText.costum1(
                                      ARMOYU.appUsers[index].user.value
                                          .displayName
                                          .toString(),
                                    ),
                                    onTap: () {
                                      final controller2 =
                                          Get.put(AppPageController());

                                      controller2.changeAccount(
                                        ARMOYU.appUsers[index],
                                      );
                                    },
                                  );
                                }),
                                ListTile(
                                  leading: const Icon(Icons.person_add_rounded),
                                  title: CustomText.costum1(
                                    "Hesap Ekle",
                                    color: Colors.blue,
                                  ),
                                  onTap: () async {
                                    final result =
                                        await Get.toNamed("/login", arguments: {
                                      "currentUser": pagesController
                                          .currentUserAccounts.value!.user,
                                      "accountAdd": true,
                                    });

                                    if (result != null) {
                                      log(result.toString());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Obx(
                () => CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                    findCurrentAccountController.currentUserAccounts.value.user
                        .value.avatar!.mediaURL.minURL.value,
                  ),
                ),
              ),
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Get.theme.primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
