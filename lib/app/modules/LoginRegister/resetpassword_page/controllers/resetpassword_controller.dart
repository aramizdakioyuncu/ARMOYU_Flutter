import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetpasswordController extends GetxController {
  var emailController = TextEditingController().obs;
  var usernameController = TextEditingController().obs;

  var codeController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var repasswordController = TextEditingController().obs;

  var passwordtimer = 120.obs;
  var countdownColor = Colors.green.obs;

  var step1 = true.obs;
  var step2 = false.obs;
  var isSelected = [false, true].obs;

  var resetpasswordProcess = false.obs;
  var resetpasswordauthProcess = false.obs;
  DateTime dateTime = DateTime.now();
  Timer? timer;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (passwordtimer.value == 0) {
          // setState(() {
          countdownColor.value = Colors.red;
          timer.cancel();
          // });
        } else {
          passwordtimer.value--;

          if (passwordtimer.value < 30) {
            countdownColor.value = Colors.red;
          } else if (passwordtimer.value < 60) {
            countdownColor.value = Colors.orange;
          } else if (passwordtimer < 90) {
            countdownColor.value = Colors.yellow;
          } else if (passwordtimer < 120) {
            countdownColor.value = Colors.green;
          }
        }
      },
    );
  }

  Future<void> forgotmypassword() async {
    if (resetpasswordProcess.value) {
      return;
    }

    if (emailController.value.text == "" ||
        usernameController.value.text == "") {
      String text = "Boş olan bırakmayın!";
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      return;
    }

    String type = "mail";
    if (isSelected[0] == true) {
      type = "telefon";
    }

    resetpasswordProcess.value = true;

    FunctionService f =
        FunctionService(currentUser: User(userName: "".obs, password: "".obs));
    ServiceResult response = await f.forgotpassword(
      usernameController.value.text,
      emailController.value.text,
      type,
    );

    if (!response.status) {
      String text = response.description;
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      log(text);
      resetpasswordProcess.value = false;
      return;
    }

    passwordtimer.value = response.descriptiondetail;
    step1.value = false;
    step2.value = true;
    resetpasswordProcess.value = false;
    startTimer();
  }

  Future<void> forgotmypassworddone() async {
    // setState(() {
    resetpasswordauthProcess.value = true;
    // });

    if (codeController.value.text == "" ||
        passwordController.value.text == "" ||
        repasswordController.value.text == "") {
      String text = "Boş alan bırakmayın!";
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      log(text);

      // setState(() {
      resetpasswordauthProcess.value = false;
      // });
      return;
    }

    if (passwordController.value.text != repasswordController.value.text) {
      String text = "Parolalar uyuşmadı!";
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      log(text);

      // setState(() {
      resetpasswordauthProcess.value = false;
      // });
      return;
    }

    FunctionService f =
        FunctionService(currentUser: User(userName: "".obs, password: "".obs));
    ServiceResult response = await f.forgotpassworddone(
      // yeniformat,
      usernameController.value.text,
      emailController.value.text,
      codeController.value.text,
      passwordController.value.text,
      repasswordController.value.text,
    );

    if (!response.status) {
      String text = response.description;
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      log(text);

      resetpasswordauthProcess.value = false;
      return;
    }
    step1.value = true;
    step2.value = false;
    Get.back();
  }
}
