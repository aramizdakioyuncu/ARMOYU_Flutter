import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/Settings/listtile.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var settingsController = TextEditingController().obs;

  var listSettings = <WidgetSettings>[
    WidgetSettings(
      listtileIcon: Icons.phone_android_rounded,
      listtileTitle: SettingsKeys.devicePermissions.obs,
      onTap: () {
        Get.toNamed("/settings/devicepermission");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.download_rounded,
      listtileTitle: (SettingsKeys.downloadAndArchive).obs,
      onTap: () {},
    ),
    WidgetSettings(
      listtileIcon: Icons.network_wifi_3_bar_rounded,
      listtileTitle: (SettingsKeys.dataSaver).obs,
      onTap: () {
        Get.toNamed("/settings/datasaver");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.language,
      listtileTitle: (SettingsKeys.languages).obs,
      onTap: () {
        Get.toNamed("/settings/languages");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.notifications_active,
      listtileTitle: (SettingsKeys.notifications).obs,
      onTap: () {
        Get.toNamed("/settings/notifications");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.block,
      listtileTitle: (SettingsKeys.blockedList).obs,
      onTap: () {
        Get.toNamed("/settings/blockedlist");
      },
    ),
  ].obs;
  var filteredlistSettings = <WidgetSettings>[].obs;
  var listSettingssupport = <WidgetSettings>[].obs;
  var filteredlistSettingssupport = <WidgetSettings>[].obs;

  Future<void> logoutfunction() async {
    if (ARMOYU.appUsers.length - 1 == 0) {
      Get.offAllNamed("/login", arguments: {
        "currentUser": currentUserAccounts.value.user.value,
        "logOut": currentUserAccounts.value.user.value,
      });
    } else {
      final appPageController = Get.find<AppPageController>();

      FunctionService f = FunctionService();
      Map<String, dynamic> response =
          await f.logOut(currentUserAccounts.value.user.value.userID!);

      if (response["durum"] == 0) {
        log(response["aciklama"]);
        ARMOYUWidget.toastNotification(response["aciklama"].toString());
        return;
      }

      appPageController.changeAccount(ARMOYU.appUsers.first);
    }
  }

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );
  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts = findCurrentAccountController.currentUserAccounts;

    listSettingssupport.value = [
      WidgetSettings(
        listtileIcon: Icons.help,
        listtileTitle: (SettingsKeys.help).obs,
        onTap: () {
          Get.toNamed("/settings/help");
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.person,
        listtileTitle: (SettingsKeys.accountStatus).obs,
        onTap: () {
          Get.toNamed("/settings/accountstatus");
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.info,
        listtileTitle: (SettingsKeys.about).obs,
        onTap: () {
          Get.toNamed("/settings/about");
        },
      ),
    ];

    filteredlistSettings.value = listSettings;
    filteredlistSettingssupport.value = listSettingssupport;

    settingsController.value.addListener(() {
      String newText = settingsController.value.text.toLowerCase();
      // Filtreleme işlemi
      filteredlistSettings.value = listSettings.where((item) {
        return item.listtileTitle.toLowerCase().contains(newText);
      }).toList();
      // Filtreleme işlemi
      filteredlistSettingssupport.value = listSettingssupport.where((item) {
        return item.listtileTitle.toLowerCase().contains(newText);
      }).toList();
    });
  }
}
