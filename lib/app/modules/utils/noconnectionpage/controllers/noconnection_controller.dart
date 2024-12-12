import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/apppage/views/app_page_view.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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

      LoginResponse response =
          await f.login(username.toString(), password.toString(), true);
      log("Durum ${response.result.status}");
      log("aciklama ${response.result.description}");

      if (!response.result.status) {
        if (response.result.description == "Hatalı giriş!") {
          log("Oturum kapatılıyor");

          Get.offNamed(
            "/Login",
            arguments: {
              "currentUser": User(userName: "".obs, password: "".obs)
            },
          );
          isConnected.value = false;
          connectionProcess.value = false;

          return;
        }
        //Hesap hatalı değil ama bağlantı yoksa
        isConnected.value = false;
        connectionProcess.value = false;
        return;
      }

      log("Oturum açılıyor");

      UserAccounts newUser = ARMOYU.appUsers.first;

      Get.off(const AppPageView(),
          arguments: {'userID': newUser.user.value.userID!});

      isConnected.value = true;
      connectionProcess.value = false;
      return;
    } else {
      isConnected.value = false;
      connectionProcess.value = false;
    }
  }
}
