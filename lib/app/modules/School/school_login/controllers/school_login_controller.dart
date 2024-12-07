import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/school_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
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
      'logo': "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png"
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
      "https://aramizdakioyuncu.com/galeri/ana-yapi/armoyu.png".obs;

  Future<void> loginschool() async {
    if (schoolProcess.value) {
      return;
    }
    schoolProcess.value = true;
    SchoolAPI f = SchoolAPI(currentUser: currentUser.value!);
    String? schoolID = cupertinolist[selectedcupertinolist.value]["ID"];
    String? classID = cupertinolist2[selectedcupertinolist2.value]["ID"];
    String? jobID = "123";
    String classPassword = schoolpassword.value.text;

    Map<String, dynamic> response = await f.joinschool(
      schoolID: schoolID!,
      classID: classID!,
      jobID: jobID,
      classPassword: classPassword,
    );

    String gelenyanit = response["aciklama"];
    // if (mounted) {
    ARMOYUWidget.stackbarNotification(Get.context!, gelenyanit);
    // }

    if (response["durum"] == 1) {
      // if (mounted) {
      // Navigator.of(context).pop();
      Get.back();
      // }
    }
    // setState(() {
    schoolProcess.value = false;
    // });
  }

  var schoolpassword = TextEditingController().obs;

  Future<void> handleRefresh() async {}

  Future<void> getschools(List<Map<String, String>> listname) async {
    SchoolAPI f = SchoolAPI(currentUser: currentUser.value!);
    Map<String, dynamic> response = await f.getschools();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    listname.add({'ID': "-1", 'value': "Okul Seç", 'logo': schoollogo.value});
    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["ID"].toString(),
        'value': element["Value"],
        'logo': element["okul_ufaklogo"]
      });
    }
  }

  Future<void> getschoolclass(
      String schoolID, List<Map<String, String>> listname) async {
    SchoolAPI f = SchoolAPI(currentUser: currentUser.value!);

    log(schoolID);
    Map<String, dynamic> response = await f.getschoolclass(schoolID: schoolID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    listname.add({
      'ID': "-1",
      'value': "Sınıf Seç",
    });

    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["ID"].toString(),
        'value': element["Value"],
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
