// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';

import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/buttons.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoConnectionPage extends StatefulWidget {
  @override
  _InternetCheckPageState createState() => _InternetCheckPageState();
}

class _InternetCheckPageState extends State<NoConnectionPage> {
  bool _isConnected = true;
  String connectionstatus = 'İnternet Bağlantısı Yok!';
  IconData networkicon = Icons.signal_wifi_off;
  bool connectionProcess = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> checkInternetConnection2() async {
    connectionProcess = true;

    if (await AppCore.checkInternetConnection()) {
      setState(() {
        _isConnected = true;
        log(_isConnected.toString());
        networkicon = Icons.signal_wifi_4_bar;
        connectionstatus = "İnternet Bağlantısı Var";
      });

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      final password = prefs.getString('password');
      FunctionService f = FunctionService();

//Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
      if (username == null || password == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        connectionProcess = false;

        return;
      }

      Map<String, dynamic> response =
          await f.login(username.toString(), password.toString(), true);
      if (response["durum"] == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Pages()));
        connectionProcess = false;

        return;
      }
      try {
        ARMOYU.SecurityDetail = response["projegizliliksozlesmesi"];
      } catch (e) {}

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      connectionProcess = false;

      return;
    } else {
      setState(() {
        _isConnected = false;
        log(_isConnected.toString());
      });
      connectionProcess = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              networkicon,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              connectionstatus,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            CustomButtons().Costum1(
                "Tekrar dene", checkInternetConnection2, connectionProcess),
          ],
        ),
      ),
    );
  }
}
