import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/routes/app_pages.dart';
import 'package:ARMOYU/app/theme/app_theme.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ARMOYU',
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      themeMode: ThemeMode.dark,
      translationsKeys: AppTranslation.translationKeys,
      // locale: Get.deviceLocale,
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorKey: AppCore.navigatorKey,
    );
  }
}
