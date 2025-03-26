import 'dart:developer';

import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/textfields.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollCreateController extends GetxController {
  var media = <Media>[].obs;
  var t1 = TextEditingController().obs;
  var t2 = TextEditingController().obs;
  var answercounter = 3.obs;
  var answerlist = <Map<int, Widget>>[].obs;
  var controllers = <TextEditingController>[].obs;

  late var user = Rxn<User>();

  var poolproccess = false.obs;
  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    user.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;
    answerlist.value = [
      {
        1: CustomTextfields.costum3(
            title: "1.${PollKeys.pollOption.tr}", controller: t1),
      },
      {
        2: CustomTextfields.costum3(
            title: "2.${PollKeys.pollOption.tr}", controller: t2),
      }
    ];
    controllers.value = [
      t1.value,
      t2.value,
    ];
  }

  void setstatefunction() {}

  var anwserIcon = Icons.radio_button_checked.obs;

  void addtextfield() {
    final int countID = answercounter.value;

    var t = TextEditingController().obs;
    answerlist.add({
      countID: CustomTextfields.costum3(
        title: PollKeys.pollOption.tr,
        controller: t,
        suffixiconbutton: IconButton(
          onPressed: () {
            log(answercounter.value.toString());
            answerlist.removeWhere((element) => element.keys.first == countID);
            // setstatefunction();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    });

    controllers.add(t.value);
    answercounter.value++;
    setstatefunction();
  }

  var surveyDate = Rx<String?>(null);
  var surveyTime = Rx<String?>(null);
  var controllerSurveyQuestion = TextEditingController().obs;
  var controllerOptions = TextEditingController().obs;
  var selectedValue =
      (PollKeys.selectPollMultipleChoice.tr).obs; // Başlangıçta seçili değer
}
