import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/loginregister.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/apppage/views/app_page_view.dart';
// import 'package:ARMOYU/app/modules/apppage/views/eski_app_page.dart';
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

  void setstatefunction() {
    // if (mounted) {
    //   setState(() {});
    // }
  }

  Future<void> invitecodeTester(String code) async {
    if (inviteCodeProcces.value) {
      return;
    }
    // setState(() {
    inviteCodeProcces.value = true;
    // });

    FunctionsLoginRegister f =
        FunctionsLoginRegister(currentUser: User(userName: "", password: ""));
    Map<String, dynamic> response = await f.inviteCodeTest(code);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      // if (mounted) {
      ARMOYUWidget.stackbarNotification(Get.context!, response["aciklama"]);
      // }
      // setState(() {
      inviteCodeProcces.value = false;
      // });
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
    // setState(() {
    registerProccess.value = true;
    // });
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

      // setState(() {
      registerProccess.value = false;
      // });
      return;
    }
    if (password != rpassword) {
      String text = "Parolalarınız eşleşmedi!";
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      log(text);

      // setState(() {
      registerProccess.value = false;
      // });
      return;
    }

    FunctionService f =
        FunctionService(currentUser: User(userName: "", password: ""));
    Map<String, dynamic> response = await f.register(
        username, name, lastname, email, password, rpassword, inviteCode);

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      // if (mounted) {
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      // }
      // setState(() {
      registerProccess.value = false;
      // });
      return;
    }

    if (response["durum"] == 1) {
      Map<String, dynamic> loginresponse =
          await f.login(username, password, true);

      if (loginresponse["aciklama"] == "Başarılı.") {
        // if (mounted) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Pages(
        //         currentUser: ARMOYU.appUsers[0],
        //       ),
        //     ),
        //   );
        // }

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

        Get.offAll(
          () => const AppPageView(),
          arguments: {'userID': newUser.user.userID!},
        );
        return;
      }

      // setState(() {
      registerProccess.value = false;
      // });
    }
  }
}
