// ignore_for_file: use_key_in_widget_constructors

import 'package:ARMOYU/Screens/login_page.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/services/functions_service.dart';
import 'package:ARMOYU/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Bu satırı eklemeyi unutmayın
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  final password = prefs.getString('password');
  final thememode = prefs.getString('thememode');

  final themeProvider = ThemeProvider(); // ThemeProvider sınıfını oluşturun

  if (username != null) {
    usernameController.text = username.toString();
  }
  if (password != null) {
    passwordController.text = password.toString();
  }

  if (thememode == "dark") {
    themeProvider.toggleTheme();
  }

//Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
  if (username == null || password == null) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => themeProvider,
        child: MyApp(homePage: LoginPage(), thememode: themeProvider),
      ),
    );
    return;
  }

  FunctionService f = FunctionService();
  Map<String, dynamic> response =
      await f.login(username.toString(), password.toString(), true);
  if (response["durum"] == 1) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => themeProvider,
        child: MyApp(homePage: MainPage(), thememode: themeProvider),
      ),
    );
    return;
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: MyApp(homePage: LoginPage(), thememode: themeProvider),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget homePage;
  final ThemeProvider thememode;

  const MyApp({Key? key, required this.homePage, required this.thememode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARMOYU',
      theme: thememode.themeData,
      home: homePage,
      debugShowCheckedModeBanner: false,
    );
  }
}
