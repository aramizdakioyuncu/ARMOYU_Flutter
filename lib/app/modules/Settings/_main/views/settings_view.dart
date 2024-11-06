import 'dart:developer';
import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/Account/accountsettings.dart';
import 'package:ARMOYU/app/modules/Settings/_main/controller/settings_controller.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';

import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;

    UserAccounts currentUserAccounts = arguments['currentUserAccounts'];

    final currentAccountController = Get.find<PagesController>(
      tag: currentUserAccounts.user.userID.toString(),
    );
    log("***-**${currentAccountController.currentUserAccounts.user.displayName}");

    final controller = Get.put(
      SettingsController(
        currentUserAccounts: currentAccountController.currentUserAccount,
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText.costum1('Ayarlar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(color: ARMOYU.bodyColor, height: 1),
                  ListTile(
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundImage: CachedNetworkImageProvider(
                        currentUserAccounts.user.avatar!.mediaURL.minURL.value,
                      ),
                      radius: 28,
                    ),
                    title: CustomText.costum1(
                        currentUserAccounts.user.displayName!),
                    subtitle: CustomText.costum1(
                        "Hatalı Giriş: ${currentUserAccounts.user.lastfaillogin}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsAccountPage(),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.qr_code),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: ARMOYU.bodyColor,
                      ),
                      child: TextField(
                        controller: controller.settingsController.value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                          ),
                          hintText: 'Ara',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.5),
                  Obx(
                    () => Visibility(
                      visible: controller.filteredlistSettings.isNotEmpty,
                      child: ListTile(
                        tileColor: Get.theme.scaffoldBackgroundColor,
                        title: CustomText.costum1("Uygulaman ve medya"),
                      ),
                    ),
                  ),
                  Obx(
                    () => Column(
                      children: List.generate(
                          controller.filteredlistSettings.length, (index) {
                        return controller.filteredlistSettings[index]
                            .listtile(context);
                      }),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.filteredlistSettings.isNotEmpty,
                      child: Container(
                        color: ARMOYU.bodyColor,
                        height: 2.5,
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible:
                          controller.filteredlistSettingssupport.isNotEmpty,
                      child: ListTile(
                        tileColor: Get.theme.scaffoldBackgroundColor,
                        title: CustomText.costum1("Daha fazla bilgi ve destek"),
                      ),
                    ),
                  ),
                  Obx(
                    () => Column(
                      children: List.generate(
                          controller.filteredlistSettingssupport.length,
                          (index) {
                        return controller.filteredlistSettingssupport[index]
                            .listtile(context);
                      }),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible:
                          controller.filteredlistSettingssupport.isNotEmpty,
                      child: Container(
                        color: ARMOYU.bodyColor,
                        height: 2.5,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        tileColor: Get.theme.scaffoldBackgroundColor,
                        title: CustomText.costum1(
                          "Hesap Ekle",
                          color: Colors.blue,
                        ),
                        onTap: () async {
                          final result = Get.toNamed("/login", arguments: {
                            "currentUser": currentUserAccounts.user,
                            "accountAdd": true,
                          });

                          if (result != null) {
                            log(result.toString());
                          }
                        },
                      ),
                      ListTile(
                        tileColor: Get.theme.scaffoldBackgroundColor,
                        title: CustomText.costum1(
                          "Çıkış Yap",
                          color: Colors.red,
                        ),
                        onTap: () => controller.logoutfunction(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomText.costum1(
                      "Versiyon : ${ARMOYU.appVersion.toString()} (${ARMOYU.appBuild.toString()})",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
