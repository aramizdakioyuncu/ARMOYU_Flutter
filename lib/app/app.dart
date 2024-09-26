import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/routes/app_pages.dart';
import 'package:ARMOYU/app/services/Utility/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.startingTheme();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ARMOYU',
      theme: themeProvider.themeData,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorKey: AppCore.navigatorKey,
    );
  }
}
