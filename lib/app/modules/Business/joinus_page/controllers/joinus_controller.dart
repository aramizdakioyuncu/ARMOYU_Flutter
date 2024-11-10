import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/joinus.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinusController extends GetxController {
  var departmentList = <Map<int, dynamic>>[].obs;
  var departmentdetailList = <Map<int, dynamic>>[].obs;
  var filtereddepartmentdetailList = <Map<int, dynamic>>[].obs;

  var whyjointheteamController = TextEditingController().obs;
  var whypositionController = TextEditingController().obs;
  var howmuchtimedoyouspareController = TextEditingController().obs;

  var category = Rx<String?>(null);
  var categorydetail = Rx<String?>(null);
  var positionID = Rx<int?>(null);
  var departmentabout = Rx<String>("");
  var requestProccess = false.obs;
  late var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;
    if (departmentList.isEmpty) {
      fetchdepartmentInfo();
    }
  }

  Future<void> requestjoinfunction() async {
    if (positionID.value == null) {
      return;
    }

    if (requestProccess.value) {
      return;
    }

    if (whyjointheteamController.value.text.length < 20 ||
        200 < whyjointheteamController.value.text.length) {
      ARMOYUWidget.stackbarNotification(
          Get.context!, "neden ekibe katılmak istiyorsun yetersiz girilmiş!");
      return;
    }

    if (whypositionController.value.text.length < 10 ||
        100 < whypositionController.value.text.length) {
      ARMOYUWidget.stackbarNotification(
          Get.context!, "Neden bu yetkiyi seçtin yetersiz girilmiş!");
      return;
    }

    if (howmuchtimedoyouspareController.value.text.length < 5 ||
        50 < howmuchtimedoyouspareController.value.text.length) {
      ARMOYUWidget.stackbarNotification(
          Get.context!, "Bize kaç gün ayırabilirsin yetersiz girilmiş!");
      return;
    }
    requestProccess.value = true;

    FunctionsJoinUs f = FunctionsJoinUs(currentUser: currentUser.value!);
    Map<String, dynamic> response = await f.requestjoindepartment(
        positionID.value!,
        whyjointheteamController.value.text,
        whypositionController.value.text,
        howmuchtimedoyouspareController.value.text);

    if (response["durum"] == 0) {
      log(response["aciklama"]);

      ARMOYUWidget.stackbarNotification(Get.context!, response["aciklama"]);

      requestProccess.value = false;

      return;
    }

    Get.back();
  }

  Future<void> fetchdepartmentInfo() async {
    FunctionsJoinUs f = FunctionsJoinUs(currentUser: currentUser.value!);
    Map<String, dynamic> response = await f.fetchdepartment();

    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    for (var departmentInfo in response["icerik"]) {
      log(departmentInfo["Value"].toString());
      if (departmentInfo["Value"] == "Kurucu") {
        continue;
      }
      if (departmentInfo["category"] != null) {
        if (!departmentList.any((info) =>
            info.values.first['category'] == departmentInfo['category'])) {
          departmentList.add({
            departmentInfo["ID"]: {
              "ID": departmentInfo["ID"],
              "category": departmentInfo["category"],
              "value": departmentInfo["Value"],
              "about": departmentInfo["about"],
            },
          });
        }
      }
      departmentdetailList.add({
        departmentInfo["ID"]: {
          "ID": departmentInfo["ID"],
          "category": departmentInfo["category"],
          "value": departmentInfo["Value"],
          "about": departmentInfo["about"],
        }
      });
    }
  }
}
