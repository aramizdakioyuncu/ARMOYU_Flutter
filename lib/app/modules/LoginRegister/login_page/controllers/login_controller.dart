import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/user.dart';

import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/functions/functions_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  var loginProcess = false.obs;

  var usernameController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  late var user = Rxn<User>();

  late var accountAdd = false.obs;
  late var currentUser = Rxn<User>();
  late AccountUserController accountController;
  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;
    accountController = findCurrentAccountController;

    ///

    var logOut = Rx<User?>(null);
    final Map<String, dynamic>? arguments = Get.arguments;

    if (arguments != null) {
      if (arguments['accountAdd'] != null) {
        accountAdd.value = arguments['accountAdd'] as bool;
      }
      logOut.value = (arguments['logOut']);
    }

    if (logOut.value != null) {
      logOutFunction(logOut.value!);
    }

    if (accountAdd.value) {
      usernameController.value.text = "";
      passwordController.value.text = "";
    }
  }

  Future<void> logOutFunction(User loggoutAccount) async {
    FunctionService f = FunctionService(API.service);
    Map<String, dynamic> response = await f.logOut(loggoutAccount.userID!);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"].toString());
      return;
    }
  }

  Future<void> login() async {
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

    //2.Hesap Ekle
    if (accountAdd.value) {
      FunctionService f = FunctionService(API.service);
      LoginResponse response = await f.adduserAccount(username, password);

      if (!response.result.status ||
          response.result.description == "Oyuncu bilgileri yanlış!") {
        String gelenyanit = response.result.description;

        ARMOYUWidget.stackbarNotification(Get.context!, gelenyanit);
        Get.snackbar("Oyuncu bilgileri yanlış!", gelenyanit);

        loginProcess.value = false;
        return;
      }

      loginProcess.value = false;

      Get.delete<AppPageController>();

      Get.offAndToNamed("/app", arguments: {});

      // Get.back();
      return;
    }

    FunctionService f = FunctionService(API.service);
    LoginResponse response = await f.login(username, password);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      String gelenyanit = response.result.description;

      Get.snackbar("Oyuncu bilgileri yanlış!", gelenyanit);
      ARMOYUWidget.stackbarNotification(Get.context!, gelenyanit);

      loginProcess.value = false;

      return;
    }

    usernameController.value.text = "";
    passwordController.value.text = "";

    loginProcess.value = false;

    Get.offAndToNamed("/app", arguments: {
      'currentUserAccounts': ARMOYU.appUsers,
    });
  }
}
