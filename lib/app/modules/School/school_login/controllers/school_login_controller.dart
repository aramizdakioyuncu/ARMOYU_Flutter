import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/core/widgets.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/school/school_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/station/station_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SchoolLoginController extends GetxController {
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

    getschools(cupertinolist);
  }

  var kItemExtent = 32.0.obs;
  var cupertinolist = [
    {
      'ID': '-1',
      'value': 'Seç',
      'logo': "https://api.aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png"
    }
  ].obs;
  var cupertinolist2 = [
    {
      'ID': '-1',
      'value': 'Sınıf Seç',
    }
  ].obs;

  var schoolProcess = false.obs;
  var selectedcupertinolist = 0.obs;
  var selectedcupertinolist2 = 0.obs;

  var schoollogo =
      "https://api.aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png".obs;

  Future<void> loginschool() async {
    if (schoolProcess.value) {
      return;
    }
    schoolProcess.value = true;

    String? schoolID = cupertinolist[selectedcupertinolist.value]["ID"];
    String? classID = cupertinolist2[selectedcupertinolist2.value]["ID"];
    String? jobID = "123";
    String classPassword = schoolpassword.value.text;

    ServiceResult response = await API.service.schoolServices.joinWorkstation(
      workstationID: schoolID!,
      classID: classID!,
      jobID: jobID,
      classPassword: classPassword,
    );

    String gelenyanit = response.description;

    ARMOYUWidget.stackbarNotification(Get.context!, gelenyanit);

    if (response.status) {
      Get.back();
    }
    schoolProcess.value = false;
  }

  var schoolpassword = TextEditingController().obs;

  Future<void> handleRefresh() async {}

  Future<void> getschools(List<Map<String, String>> listname) async {
    SchoolFetchListResponse response =
        await API.service.schoolServices.getschools();
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    listname.clear();
    listname.add({'ID': "-1", 'value': "Okul Seç", 'logo': schoollogo.value});

    for (APISchoolList element in response.response!) {
      listname.add({
        'ID': element.schoolID.toString(),
        'value': element.value,
        'logo': element.schoolLogo.minURL
      });
    }
  }

  Future<void> getschoolclass(
      String schoolID, List<Map<String, String>> listname) async {
    StationFetchDetailResponse response = await API.service.schoolServices
        .fetchWorkstationDetail(workStationID: schoolID);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    listname.clear();
    listname.add({
      'ID': "-1",
      'value': "Sınıf Seç",
    });

    for (APIStationDetail element in response.response!) {
      listname.add({
        'ID': element.id.toString(),
        'value': element.value,
      });
    }
  }

  void showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
