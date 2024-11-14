import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/apppage/views/app_page_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoconnectionapageController extends GetxController {
  var isConnected = false.obs;
  var connectionProcess = false.obs;

  Future<void> checkInternetConnection2() async {
    connectionProcess.value = true;

    log("message");

    if (await AppCore.checkInternetConnection()) {
      isConnected.value = true;

      final prefs = await SharedPreferences.getInstance();

      // Kullanıcı listesini SharedPreferences'den yükleme
      List<String>? usersJson = prefs.getStringList('users');

      String? username;
      String? password;

      if (usersJson != null) {
        //Listeye Yükle
        ARMOYU.appUsers.value = usersJson
            .map((userJson) => UserAccounts.fromJson(jsonDecode(userJson)))
            .toList();
        for (var element in usersJson) {
          username = ARMOYU.appUsers.first.user.value.userName!.value;
          password = ARMOYU.appUsers.first.user.value.password!.value;
          log(element.toString());
        }
      }
      log(ARMOYU.appUsers.length.toString());

      //Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
      if (username == null || password == null) {
        // if (mounted) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => LoginPage(
        //         currentUser: User(userName: "", password: ""),
        //       ),
        //     ),
        //   );
        // }
        Get.offNamed(
          "/Login",
          arguments: {"currentUser": User(userName: "".obs, password: "".obs)},
        );

        // setState(() {
        isConnected.value = false;
        connectionProcess.value = false;
        // });
        return;
      }
      FunctionService f = FunctionService(
          currentUser: User(userName: "".obs, password: "".obs));

      Map<String, dynamic> response =
          await f.login(username.toString(), password.toString(), true);
      log("Durum ${response["durum"]}");
      log("aciklama ${response["aciklama"]}");

      if (response["durum"] == 0) {
        if (response["aciklama"] == "Hatalı giriş!") {
          log("Oturum kapatılıyor");
          // if (mounted) {
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => LoginPage(
          //         currentUser: User(userName: "", password: ""),
          //       ),
          //     ),
          //   );
          // }

          Get.offNamed(
            "/Login",
            arguments: {
              "currentUser": User(userName: "".obs, password: "".obs)
            },
          );
          // setState(() {
          isConnected.value = false;
          connectionProcess.value = false;
          // });

          return;
        }
        //Hesap hatalı değil ama bağlantı yoksa
        // setState(() {
        isConnected.value = false;
        connectionProcess.value = false;
        // });
        return;
      }

      log("Oturum açılıyor");

      // // if (mounted) {
      // //   Navigator.pushReplacement(
      // //     context,
      // //     MaterialPageRoute(
      // //       builder: (context) => Pages(
      // //         currentUser: ARMOYU.appUsers[0],
      // //       ),
      // //     ),
      // //   );
      // // }

      UserAccounts newUser = ARMOYU.appUsers.first;
      // if (mounted) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => AppPage(
      //         userID: newUser.user.userID!,
      //       ),
      //     ),
      //   );
      // }
      Get.off(const AppPageView(),
          arguments: {'userID': newUser.user.value.userID!});

      // setState(() {
      isConnected.value = true;
      connectionProcess.value = false;
      // });
      return;
    } else {
      // setState(() {
      isConnected.value = false;
      connectionProcess.value = false;
      // });
    }
  }
}
