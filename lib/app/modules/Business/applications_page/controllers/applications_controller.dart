import 'dart:developer';

import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/joinus.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationsController extends GetxController {
  var applicationList = [].obs;
  var page = 1.obs;
  var requestProccess = false.obs;

  late var currentUser = Rxn<User>();

  @override
  void onInit() {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;
    super.onInit();
    if (applicationList.isEmpty) {
      fetchapplicationInfo();
    }
  }

  Future<void> fetchapplicationInfo({bool firstpage = false}) async {
    if (firstpage) {
      applicationList.clear();
      page.value = 1;
    }
    if (requestProccess.value) {
      return;
    }
    requestProccess.value = true;
    FunctionsJoinUs f = FunctionsJoinUs(currentUser: currentUser.value!);
    Map<String, dynamic> response = await f.applicationList(page.value);

    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      requestProccess.value = false;
      return;
    }

    for (var departmentInfo in response["icerik"]) {
      applicationList.add(
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.star_outline_sharp),
          title: CustomText.costum1(
            departmentInfo["sapplication_position"]["position_name"],
          ),
          subtitle: CustomText.costum1(
            departmentInfo["sapplication_position"]["position_department"],
            color: Colors.black.withOpacity(0.6),
          ),
          trailing: departmentInfo["sapplication_status"] == 2
              ? CustomText.costum1("İnceleniyor")
              : departmentInfo["sapplication_status"] == 1
                  ? CustomText.costum1("Kabul Edildi")
                  : departmentInfo["sapplication_status"] == 0
                      ? CustomText.costum1("Reddedildi")
                      : null,
        ),
      );
    }
    page.value++;
    requestProccess.value = false;
  }
}
