import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/aboutsettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/accountstatussettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/blockedusersettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/datasavingsetting.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/devicepermissions.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/helpsettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/notificationsetttings.dart';
import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:ARMOYU/app/widgets/Settings/listtile.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final UserAccounts currentUserAccounts;
  SettingsController({required this.currentUserAccounts});

  var settingsController = TextEditingController().obs;

  // List<Map<int, String>> languageList = [];
  var languageList = RxList<Map<int, String>>([]);

  List<Map<String, String>> cupertinolist = [
    {'ID': '-1', 'value': 'Seç'}
  ];
  var selectedLanguage = "Türkçe".obs;
  var listSettings = RxList<WidgetSettings>([]);
  var filteredlistSettings = RxList<WidgetSettings>([]);
  var listSettingssupport = RxList<WidgetSettings>([]);
  var filteredlistSettingssupport = RxList<WidgetSettings>([]);

  setstatefunction() {
    // setState(() {});
  }

  Future<void> logoutfunction() async {
    if (ARMOYU.appUsers.length - 1 == 0) {
      Get.offAllNamed("/login", arguments: {
        "currentUser": currentUserAccounts.user,
        "logOut": currentUserAccounts.user,
      });
    } else {
      // pagecontrollera erişilemediği için yorum satırına alındı

      final appPageController = Get.find<AppPageController>();

      FunctionService f =
          FunctionService(currentUser: currentUserAccounts.user);
      Map<String, dynamic> response =
          await f.logOut(currentUserAccounts.user.userID!);

      if (response["durum"] == 0) {
        log(response["aciklama"]);
        ARMOYUWidget.toastNotification(response["aciklama"].toString());
        return;
      }

      appPageController.changeAccount(ARMOYU.appUsers.first);
    }
  }

  @override
  void onInit() {
    super.onInit();

    languageList.add({1: "Türkçe"});
    languageList.add({1: "İngilizce"});
    languageList.add({1: "Almanca"});

    listSettings.value = [
      WidgetSettings(
        listtileIcon: Icons.phone_android_rounded,
        listtileTitle: "Cihaz İzinleri",
        onTap: () {
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => const SettingsDevicePermissionsPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.download_rounded,
        listtileTitle: "İndirme ve Arşivleme",
        tralingText: "Kapalı".obs,
        onTap: () {},
      ),
      WidgetSettings(
        listtileIcon: Icons.network_wifi_3_bar_rounded,
        listtileTitle: "Veri Tasarrufu",
        onTap: () {
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => const SettingsDataSavingPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.language,
        listtileTitle: "Diller",
        tralingText: selectedLanguage,
        onTap: () {
          WidgetUtility.cupertinoselector(
            context: Get.context!,
            title: "Dil Seçimi",
            onChanged: (selectedIndex, selectedValue) {
              log(selectedIndex.toString());
              log(selectedValue);

              listSettings[3].tralingText!.value = selectedValue;

              listSettings.refresh();
            },
            list: languageList,
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.notifications_active,
        listtileTitle: "Bildirimler",
        onTap: () {
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => SettingsNotificationPage(
                  currentUser: currentUserAccounts.user),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.block,
        listtileTitle: "Engellenenler",
        onTap: () {
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => SettingsBlockeduserPage(
                  currentUser: currentUserAccounts.user),
            ),
          );
        },
      ),
    ];

    listSettingssupport.value = [
      WidgetSettings(
        listtileIcon: Icons.help,
        listtileTitle: "Yardım",
        onTap: () {
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => const SettingsHelpPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.person,
        listtileTitle: "Hesap Durumu",
        onTap: () {
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => SettingsAccountStatusPage(
                currentUser: currentUserAccounts.user,
              ),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.info,
        listtileTitle: "Hakkında",
        onTap: () {
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
              builder: (context) => const SettingsAboutPage(),
            ),
          );
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
