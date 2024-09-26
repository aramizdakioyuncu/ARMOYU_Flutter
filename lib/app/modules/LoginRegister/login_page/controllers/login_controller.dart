import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/apppage/views/app_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  var loginProcess = false.obs;

  var usernameController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  // var currentUser = Rx<User?>(null);

  late var user = Rxn<User>();

  late var accountAdd = false.obs;
  late var logOut = Rxn<User?>();
  late var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;

    if (arguments['accountAdd'] != null) {
      accountAdd.value = arguments['accountAdd'] as bool;
    }
    logOut.value = arguments['logOut'] as User?;
    currentUser.value = arguments['currentUser'] as User;

    if (logOut.value != null) {
      logOutFunction();
    }

    if (accountAdd.value) {
      usernameController.value.text = "";
      passwordController.value.text = "";
    }
  }

  Future<void> logOutFunction() async {
    FunctionService f = FunctionService(currentUser: currentUser.value!);
    Map<String, dynamic> response = await f.logOut(logOut.value!.userID!);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"].toString());
      return;
    }
  }

  Future<void> login({required User currentUser}) async {
    if (loginProcess.value) {
      return;
    }

    String username = usernameController.value.text;
    String password = passwordController.value.text;

    if (username == "" || password == "") {
      ARMOYUWidget.stackbarNotification(
          Get.context!, "Kullanıcı adı veya Parola boş olamaz!");
      return;
    }

    loginProcess.value = true;

    log(accountAdd.value.toString());
    if (accountAdd.value) {
      FunctionService f = FunctionService(currentUser: currentUser);
      Map<String, dynamic> response =
          await f.adduserAccount(username, password);

      if (response["durum"] == 0 ||
          response["aciklama"] == "Oyuncu bilgileri yanlış!") {
        String gelenyanit = response["aciklama"];

        ARMOYUWidget.stackbarNotification(Get.context!, gelenyanit);
        Get.snackbar("Oyuncu bilgileri yanlış!", gelenyanit);

        loginProcess.value = false;
        return;
      }

      loginProcess.value = false;

      Get.back();
      return;
    }

    FunctionService f = FunctionService(currentUser: currentUser);
    Map<String, dynamic> response = await f.login(username, password, false);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      String gelenyanit = response["aciklama"];

      Get.snackbar("Oyuncu bilgileri yanlış!", gelenyanit);
      ARMOYUWidget.stackbarNotification(Get.context!, gelenyanit);

      loginProcess.value = false;

      return;
    }

    User newUser = User.fromJson(response["icerik"]);

    log(newUser.userID.toString());

    usernameController.value.text = "";
    passwordController.value.text = "";

    loginProcess.value = false;

    Get.off(() => const AppPageView(), arguments: {
      'currentUserAccounts': ARMOYU.appUsers,
    });
  }
}
