import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/school.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SchoolLoginController extends GetxController {
  final User currentUser;
  SchoolLoginController({
    required this.currentUser,
  });
  @override
  void onInit() {
    super.onInit();
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
    // setState(() {
    schoolProcess.value = true;
    // });
    FunctionsSchool f = FunctionsSchool(currentUser: currentUser);
    String? schoolID = cupertinolist[selectedcupertinolist.value]["ID"];
    String? classID = cupertinolist2[selectedcupertinolist2.value]["ID"];
    String? jobID = "123";
    String classPassword = schoolpassword.text;

    Map<String, dynamic> response =
        await f.joinschool(schoolID!, classID!, jobID, classPassword);

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

  TextEditingController schoolpassword = TextEditingController();

  Future<void> handleRefresh() async {}

  Future<void> getschools(List<Map<String, String>> listname) async {
    FunctionsSchool f = FunctionsSchool(currentUser: currentUser);
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
    FunctionsSchool f = FunctionsSchool(currentUser: currentUser);

    log(schoolID);
    Map<String, dynamic> response = await f.getschoolclass(schoolID);
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
