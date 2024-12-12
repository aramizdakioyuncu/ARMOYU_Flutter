import 'dart:developer';

import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/joinus_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/joinus/joinus_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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
    JoinusAPI f = JoinusAPI(currentUser: currentUser.value!);
    JoinUsApplicationsResponse response =
        await f.applicationList(page: page.value);

    if (!response.result.status) {
      log(response.result.description.toString());
      requestProccess.value = false;
      return;
    }

    for (APIJoinusList element in response.response!) {
      applicationList.add(
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.star_outline_sharp),
          title: CustomText.costum1(
            element.applicationPosition.positionName,
          ),
          subtitle: CustomText.costum1(
            element.applicationPosition.positionDepartment,
            color: Colors.black.withOpacity(0.6),
          ),
          trailing: element.applicationStatus == 2
              ? CustomText.costum1("İnceleniyor")
              : element.applicationStatus == 1
                  ? CustomText.costum1("Kabul Edildi")
                  : element.applicationStatus == 0
                      ? CustomText.costum1("Reddedildi")
                      : null,
        ),
      );
    }
    page.value++;
    requestProccess.value = false;
  }
}
