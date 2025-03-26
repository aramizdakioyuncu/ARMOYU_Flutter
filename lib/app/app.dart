import 'dart:convert';
import 'dart:developer';

import 'package:armoyu/app/core/appcore.dart';
import 'package:armoyu/app/routes/app_pages.dart';
import 'package:armoyu/app/theme/app_theme.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? language;
    Locale? locale;

    importantstartingfunction();
    if (ARMOYU.appUsers.isNotEmpty) {
      language = ARMOYU.appUsers.first.language.value;

      log(ARMOYU.appUsers.first.user.value.displayName!.value);
    }

    if (language != null) {
      try {
        log("|+a+|  ${language.split(' ')[0]}, ${language.split(' ')[1]} ");
        locale = Locale(language.split(' ')[0], language.split(' ')[1]);
      } catch (e) {
        log(e.toString());
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ARMOYU',
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      themeMode: ThemeMode.dark,
      translationsKeys: AppTranslation.translationKeys,
      locale: locale ?? Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorKey: AppCore.navigatorKey,
    );
  }

  importantstartingfunction() {
    // Bellekteki Kullanıcı listesini Storeage'den yükleme
    List<dynamic>? usersJson = ARMOYU.storage.read("users");

    //Listeye Yükle
    try {
      ARMOYU.appUsers.value = usersJson!
          .map((userJson) => UserAccounts.fromJson(jsonDecode(userJson)))
          .toList();
    } catch (e) {
      log("Önbellek Yükleme Hatası !! $e");
    }
  }
}
