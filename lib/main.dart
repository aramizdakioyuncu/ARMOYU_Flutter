// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'package:ARMOYU/Services/functions_service.dart';
import 'package:ARMOYU/Services/theme_service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'Screens/LoginRegister/login_page.dart';
import 'Screens/pages.dart';
import 'Services/App.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Bu satırı eklemeyi unutmayın ilkbaşta olmak zorunda

  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  final password = prefs.getString('password');

  if (username != null) {
    usernameController.text = username.toString();
  }

  FunctionService f = FunctionService();

//Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
  if (username == null || password == null) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(homePage: LoginPage()),
      ),
    );
    return;
  }

  Map<String, dynamic> response =
      await f.login(username.toString(), password.toString(), true);
  if (response["durum"] == 1) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(homePage: Pages()),
      ),
    );
    return;
  }
  try {
    App.SecurityDetail = response["projegizliliksozlesmesi"];
  } catch (e) {}

  prefs.remove('username');
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(homePage: LoginPage()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget homePage;
  const MyApp({Key? key, required this.homePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.StartingTheme();

    Intl.defaultLocale = 'tr_TR';
    return MaterialApp(
      title: 'ARMOYU',
      theme: themeProvider.themeData,
      home: homePage,
      debugShowCheckedModeBanner: false,
    );
  }
}
