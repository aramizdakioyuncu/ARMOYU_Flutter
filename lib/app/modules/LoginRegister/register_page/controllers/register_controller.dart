import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/services/API/loginregister_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterpageController extends GetxController {
  var usernameController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  var lastnameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var rpasswordController = TextEditingController().obs;
  var inviteController = TextEditingController().obs;

  var registerProccess = false.obs;
  var inviteCodeProcces = false.obs;

  var inviteduserID = Rx<String?>(null);
  var inviteduserdisplayName = Rx<String?>(null);
  var inviteduseravatar = Rx<String?>(null);

  Future<void> invitecodeTester(String code) async {
    if (inviteCodeProcces.value) {
      return;
    }
    // setState(() {
    inviteCodeProcces.value = true;
    // });

    LoginregisterAPI f = LoginregisterAPI(
      currentUser: User(userName: "0".obs, password: "0".obs),
    );
    Map<String, dynamic> response = await f.inviteCodeTest(code: code);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      ARMOYUWidget.stackbarNotification(Get.context!, response["aciklama"]);
      inviteCodeProcces.value = false;
      return;
    }
    log(inviteduserID.value =
        response["aciklamadetay"]["oyuncu_ID"].toString());
    log(inviteduseravatar.value =
        response["aciklamadetay"]["oyuncu_avatar"].toString());
    log(inviteduserdisplayName.value =
        response["aciklamadetay"]["oyuncu_displayName"].toString());
    // setState(() {
    inviteCodeProcces.value = false;
    // });
  }

  Future<void> register() async {
    if (registerProccess.value) {
      return;
    }
    registerProccess.value = true;
    // Kayıt işlemini burada gerçekleştirin
    final username = usernameController.value.text;
    final name = nameController.value.text;
    final lastname = lastnameController.value.text;
    final email = emailController.value.text;
    final password = passwordController.value.text;
    final rpassword = rpasswordController.value.text;
    final inviteCode = inviteController.value.text;

    if (name == "" ||
        username == "" ||
        lastname == "" ||
        email == "" ||
        password == "" ||
        rpassword == "") {
      String text = "Boş alan bırakmayınız!";
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      log(text);

      registerProccess.value = false;
      return;
    }
    if (password != rpassword) {
      String text = "Parolalarınız eşleşmedi!";
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      log(text);

      registerProccess.value = false;
      return;
    }

    FunctionService f =
        FunctionService(currentUser: User(userName: "".obs, password: "".obs));
    Map<String, dynamic> response = await f.register(
        username, name, lastname, email, password, rpassword, inviteCode);

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      registerProccess.value = false;
      return;
    }

    if (response["durum"] == 1) {
      Map<String, dynamic> loginresponse =
          await f.login(username, password, true);

      if (loginresponse["aciklama"] == "Başarılı.") {
        UserAccounts newUser = ARMOYU.appUsers.first;

        accountController.changeUser(
          UserAccounts(user: newUser.user),
        );

        Get.toNamed("/app", arguments: {'userID': newUser.user.value.userID!});
        // Get.offAll(
        //   () => const AppPageView(),
        //   arguments: {'userID': newUser.user.value.userID!},
        // );
        return;
      }

      registerProccess.value = false;
    }
  }

  void davetkodu() {
    if (inviteController.value.text.length == 5) {
      log("5 karakter yazıldı: ${inviteController.value.text}");
      invitecodeTester(
        inviteController.value.text,
      );
    }
  }

  void davetkodu2(value) {
    inviteController.refresh();
    if (value.length == 5) {
      invitecodeTester(value);
    }
  }

  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));

  late AccountUserController accountController;
  @override
  void onInit() {
    super.onInit();

    //***//
    final findCurrentAccountController = Get.find<AccountUserController>();
    accountController = findCurrentAccountController;
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    //***//
  }
}
