import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/routes/app_pages.dart';
import 'package:ARMOYU/app/theme/app_theme.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String? language;

    importantstartingfunction();
    if (ARMOYU.appUsers.isNotEmpty) {
      language = ARMOYU.appUsers.first.language.value;

      log(ARMOYU.appUsers.first.user.value.displayName!.value);
    }

    if (language != null) {
      log("|+a+|  ${language.split(' ')[0]}, ${language.split(' ')[1]} ");
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ARMOYU',
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      themeMode: ThemeMode.dark,
      translationsKeys: AppTranslation.translationKeys,
      locale: language != null
          ? Locale(language.split(' ')[0], language.split(' ')[1])
          : Get.deviceLocale,
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
