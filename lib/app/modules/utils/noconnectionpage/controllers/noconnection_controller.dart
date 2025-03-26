import 'dart:convert';
import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/core/appcore.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/apppage/views/app_page_view.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/functions/functions_service.dart';
import 'package:get/get.dart';

class NoconnectionapageController extends GetxController {
  var isConnected = false.obs;
  var connectionProcess = false.obs;

  Future<void> checkInternetConnection2() async {
    connectionProcess.value = true;

    log("message");

    if (await AppCore.checkInternetConnection()) {
      isConnected.value = true;

      // Bellekteki Kullanıcı listesini Storeage'den yükleme
      List<dynamic>? usersJson = ARMOYU.storage.read("users");

      String? username;
      String? sesssionTOKEN;

      if (usersJson != null) {
        //Listeye Yükle
        ARMOYU.appUsers.value = usersJson
            .map((userJson) => UserAccounts.fromJson(jsonDecode(userJson)))
            .toList();
        for (var element in usersJson) {
          username = ARMOYU.appUsers.first.user.value.userName!.value;
          sesssionTOKEN = ARMOYU.appUsers.first.value.sesssionTOKEN!.value;
          log(element.toString());
        }
      }
      log(ARMOYU.appUsers.length.toString());

      //Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
      if (username == null || sesssionTOKEN == null) {
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
          arguments: {"currentUser": User(userName: "".obs)},
        );

        // setState(() {
        isConnected.value = false;
        connectionProcess.value = false;
        // });
        return;
      }
      FunctionService f = FunctionService(API.service);

      LoginResponse response =
          await f.login(username.toString(), sesssionTOKEN.toString());
      log("Durum ${response.result.status}");
      log("aciklama ${response.result.description}");

      if (!response.result.status) {
        if (response.result.description == "Hatalı giriş!") {
          log("Oturum kapatılıyor");

          Get.offNamed(
            "/Login",
            arguments: {"currentUser": User(userName: "".obs)},
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
