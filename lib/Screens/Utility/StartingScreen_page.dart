import 'dart:developer';
import 'dart:io';

import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/Utility/NoConnection_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  getFlutterInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    ARMOYU.appName = packageInfo.appName;
    ARMOYU.appPackage = packageInfo.packageName;

    ARMOYU.appVersion = packageInfo.version;
    ARMOYU.appBuild = packageInfo.buildNumber;
  }

  Future<String> getdeviceModel() async {
    //Cihaz Kontrolü yaoıyoruz
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print(androidInfo.model);
      return androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print(iosInfo.utsname.machine);
      return iosInfo.utsname.machine;
    }
    return "Bilinmeyen Cihaz";
  }

  getPlatform() {
    if (Platform.isAndroid) {
      ARMOYU.devicePlatform = "Android";
    } else if (Platform.isIOS) {
      ARMOYU.devicePlatform = "IOS";
    } else {
      ARMOYU.devicePlatform = "Bilinmeyen";
    }
  }

  Future<void> staringfunctions() async {
    //Platform kontrolü yapıyoruz
    getPlatform();

    //Kameralar var mı diye kontrol
    ARMOYU.cameras = await availableCameras();

    //Cihaz Model yapıyoruz
    ARMOYU.deviceModel = await getdeviceModel();

    //Flutter Proje bilgisini çekiyoruz
    await getFlutterInfo();
    setState(() {
      log("Cihaz Modeli: ${ARMOYU.deviceModel}");
      log("Platform: ${ARMOYU.devicePlatform}");

      log("Kameralar: ${ARMOYU.cameras!.length}");

      log("Proje Adı: ${ARMOYU.appName}");
      log("Proje Versiyon: ${ARMOYU.appVersion}");
      log("Proje Build: ${ARMOYU.appBuild}");
    });

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
    //Bellekteki kullanıcı adı ve şifreyi alıyoruz
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

      if (response["aciklama"] == "Lütfen Geçerli API_KEY giriniz!") {
        if (mounted) {
          ARMOYUFunctions.updateForce(context);
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
