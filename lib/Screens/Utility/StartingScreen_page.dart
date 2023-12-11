// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/Utility/NoConnection_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartingScreen extends StatefulWidget {
  @override
  _StartingScreen createState() => _StartingScreen();
}

class _StartingScreen extends State<StartingScreen> {
  String connectionstatus = '';
  bool connectionProcess = false;
  @override
  void initState() {
    super.initState();

    staringfunctions();
  }

  Future<void> staringfunctions() async {
    // İnternet var mı diye kontrol ediyoruz!
    if (!await AppCore.checkInternetConnection()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NoConnectionPage(),
        ),
      );

      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username != null) {
      usernameController.text = username.toString();
    }

    FunctionService f = FunctionService();

    //Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
    if (username == null || password == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      return;
    }

    Map<String, dynamic> response =
        await f.login(username.toString(), password.toString(), true);
    if (response["durum"] == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Pages(),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/armoyu512.png",
              width: ARMOYU.screenWidth / 3,
            ),
            Text(
              connectionstatus,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
