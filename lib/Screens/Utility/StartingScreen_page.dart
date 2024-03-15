import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/Utility/NoConnection_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  String connectionstatus = '';
  bool connectionProcess = false;
  @override
  void initState() {
    super.initState();

    staringfunctions();
  }

  Future<void> staringfunctions() async {
    ARMOYU.cameras = await availableCameras();
    // İnternet var mı diye kontrol ediyoruz!
    if (!await AppCore.checkInternetConnection()) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NoConnectionPage(),
          ),
        );
      }

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
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }

      return;
    }

    Map<String, dynamic> response =
        await f.login(username.toString(), password.toString(), true);
    if (response["durum"] == 1) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Pages(),
          ),
        );
      }

      return;
    } else if (response["durum"] == 0) {
      if (response["aciklama"] == "Hatalı giriş!") {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
        return;
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NoConnectionPage(),
          ),
        );
      }
      return;
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
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
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
