import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/joinus_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/joinus/joinus_permission_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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

    JoinusAPI f = JoinusAPI(currentUser: currentUser.value!);
    JoinUsRequestJoinDepartmentResponse response =
        await f.requestjoindepartment(
      positionID: positionID.value!,
      whyjoin: whyjointheteamController.value.text,
      whyposition: whypositionController.value.text,
      howmachtime: howmuchtimedoyouspareController.value.text,
    );

    if (!response.result.status) {
      log(response.result.description);

      ARMOYUWidget.stackbarNotification(
          Get.context!, response.result.description);
      requestProccess.value = false;
      return;
    }

    Get.back();
  }

  Future<void> fetchdepartmentInfo() async {
    JoinusAPI f = JoinusAPI(currentUser: currentUser.value!);
    JoinUsFetchDepartmentsResponse response = await f.fetchdepartment();

    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    for (APIJoinusPermissionList element in response.response!) {
      if (element.value == "Kurucu") {
        continue;
      }

      if (!departmentList
          .any((info) => info.values.first['category'] == element.category)) {
        departmentList.add({
          element.id: {
            "ID": element.id,
            "category": element.category,
            "value": element.value,
            "about": element.about,
          },
        });
      }

      departmentdetailList.add({
        element.id: {
          "ID": element.id,
          "category": element.category,
          "value": element.value,
          "about": element.about,
        }
      });
    }
  }
}
