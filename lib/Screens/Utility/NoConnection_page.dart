import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/buttons.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoConnectionPage extends StatefulWidget {
  const NoConnectionPage({super.key});

  @override
  State<NoConnectionPage> createState() => _InternetCheckPageState();
}

class _InternetCheckPageState extends State<NoConnectionPage> {
  bool _isConnected = false;
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
      });

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      final password = prefs.getString('password');

      usernameController.text = username.toString();

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

        setState(() {
          _isConnected = false;
          connectionProcess = false;
        });
        return;
      }

      Map<String, dynamic> response =
          await f.login(username.toString(), password.toString(), true);
      log("Durum ${response["durum"]}");
      log("aciklama ${response["aciklama"]}");

      if (response["durum"] == 0) {
        if (response["aciklama"] == "Hatalı giriş!") {
          log("Oturum kapatılıyor");
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }

          setState(() {
            _isConnected = false;
            connectionProcess = false;
          });

          return;
        }
        //Hesap hatalı değil ama bağlantı yoksa
        setState(() {
          _isConnected = false;
          connectionProcess = false;
        });
        return;
      }

      log("Oturum açılıyor");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Pages(),
          ),
        );
      }

      setState(() {
        _isConnected = true;
        connectionProcess = false;
      });
      return;
    } else {
      setState(() {
        _isConnected = false;
        connectionProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isConnected
                ? const Icon(Icons.signal_wifi_4_bar,
                    size: 80, color: Colors.red)
                : const Icon(Icons.signal_wifi_off,
                    size: 80, color: Colors.red),
            const SizedBox(height: 20),
            _isConnected
                ? const Text(
                    "İnternet Sınanıyor...",
                    style: TextStyle(fontSize: 18),
                  )
                : const Text(
                    "İnternet Bağlantısı Yok!",
                    style: TextStyle(fontSize: 18),
                  ),
            const SizedBox(height: 20),
            CustomButtons.costum1("Tekrar dene",
                onPressed: checkInternetConnection2,
                loadingStatus: connectionProcess),
          ],
        ),
      ),
    );
  }
}
