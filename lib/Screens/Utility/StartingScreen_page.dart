import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/Utility/NoConnection_page.dart';
import 'package:ARMOYU/Screens/app_page.dart';
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

  Future<bool> checkInternetConnectionv2() async {
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
      return false;
    }
    return true;
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

    //Bellekteki kullanıcı adı ve şifreyi alıyoruz
    final prefs = await SharedPreferences.getInstance();

// Kullanıcı listesini SharedPreferences'den yükleme
    List<String>? usersJson = prefs.getStringList('users');

    String? username;
    String? password;

    if (usersJson != null && usersJson.isNotEmpty) {
      //Listeye Yükle
      ARMOYU.appUsers = usersJson
          .map((userJson) => User.fromJson(jsonDecode(userJson)))
          .toList();

      username = ARMOYU.appUsers.first.userName;
      password = ARMOYU.appUsers.first.password;

      // for (var element in usersJson) {
      //   // log(element.toString());
      // }

      log("Açık Kullanıcı Hesabı : ${usersJson.length}");

      int sirasay = 0;
      for (User userInfo in ARMOYU.appUsers) {
        sirasay++;

        log("$sirasay. Ad: ${userInfo.displayName}");
        if (userInfo.myFriends == null) {
          continue;
        }
        log("->Arkadaş sayısı: ${userInfo.myFriends!.length.toString()}");
        int sirasay2 = 0;

        for (User friendslist in userInfo.myFriends!) {
          sirasay2++;

          log("-->$sirasay2. Ad: ${friendslist.displayName} Son Giriş: ${friendslist.lastloginv2}");
        }
      }
    }

    //Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
    if (username == null || password == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              currentUser: User(displayName: "", password: ""),
            ),
          ),
        );
      }
      return;
    }

    if (usersJson == null) {
      bool statusinternet = await checkInternetConnectionv2();
      if (!statusinternet) {
        return;
      }
    }

    FunctionService f =
        FunctionService(currentUser: User(displayName: "", password: ""));
    Map<String, dynamic> response = await f.login(
      username.toString(),
      password.toString(),
      true,
    );

    if (response["durum"] == 1) {
      log("Web Versiyon ${response["aciklamadetay"]["build"]}  > Sistem versiyon  ${int.parse(ARMOYU.appBuild)}");
      if (response["aciklamadetay"]["build"] > int.parse(ARMOYU.appBuild)) {
        if (mounted) {
          ARMOYUFunctions.updateForce(context);
        }
        return;
      }

      if (response["aciklama"] == "Oyuncu bilgileri yanlış!") {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                currentUser: User(displayName: "", password: ""),
              ),
            ),
          );
        }
        return;
      }

      User newUser = User.fromJson(response["icerik"]);
      if (ARMOYU.appUsers.isNotEmpty) {
        newUser = ARMOYU.appUsers.first;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppPage(
              userID: newUser.userID!,
            ),
          ),
        );
      }
      return;
    } else if (response["durum"] == 0) {
      if (usersJson == null) {
        bool statusinternet = await checkInternetConnectionv2();
        if (!statusinternet) {
          return;
        }
      }

      //internet yok ama önceden giriş yapılmış verileri var
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppPage(
              userID: ARMOYU.appUsers.first.userID!,
            ),
          ),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            currentUser: User(displayName: "", password: ""),
          ),
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
