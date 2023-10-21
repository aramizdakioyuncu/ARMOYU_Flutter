import 'dart:developer';

import 'package:armoyu/Screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Bu satırı eklemeyi unutmayın
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  final password = prefs.getString('password');
  log(username.toString());
  log(password.toString());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARMOYU',
      theme: ThemeData.light(), // Varsayılan (açık tema)
      darkTheme: ThemeData.dark(), // Karanlık tema
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
