import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/Settings/listtile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var settingsController = TextEditingController().obs;

  var selectedLanguage = "".obs;
  var listSettings = <WidgetSettings>[
    WidgetSettings(
      listtileIcon: Icons.phone_android_rounded,
      listtileTitle: (SettingsKeys.devicePermissions.tr).obs,
      onTap: () {
        Get.toNamed("/settings/devicepermission");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.download_rounded,
      listtileTitle: (SettingsKeys.downloadAndArchive.tr).obs,
      onTap: () {},
    ),
    WidgetSettings(
      listtileIcon: Icons.network_wifi_3_bar_rounded,
      listtileTitle: (SettingsKeys.dataSaver.tr).obs,
      onTap: () {
        Get.toNamed("/settings/datasaver");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.language,
      listtileTitle: (SettingsKeys.languages.tr).obs,
      onTap: () {
        Get.toNamed("/settings/languages");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.notifications_active,
      listtileTitle: (SettingsKeys.notifications.tr).obs,
      onTap: () {
        Get.toNamed("/settings/notifications");
      },
    ),
    WidgetSettings(
      listtileIcon: Icons.block,
      listtileTitle: (SettingsKeys.blockedList.tr).obs,
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

      FunctionService f =
          FunctionService(currentUser: currentUserAccounts.value.user.value);
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

  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));
  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts = findCurrentAccountController.currentUserAccounts;

    selectedLanguage.value = SettingsKeys.currentLanguage.tr;

    listSettingssupport.value = [
      WidgetSettings(
        listtileIcon: Icons.help,
        listtileTitle: (SettingsKeys.help.tr).obs,
        onTap: () {
          Get.toNamed("/settings/help");
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.person,
        listtileTitle: (SettingsKeys.accountStatus.tr).obs,
        onTap: () {
          Get.toNamed("/settings/accountstatus");
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.info,
        listtileTitle: (SettingsKeys.about.tr).obs,
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
