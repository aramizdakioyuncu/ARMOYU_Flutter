import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/category.dart';
import 'package:ARMOYU/app/functions/API_Functions/group.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GroupCreateController extends GetxController {
  var kItemExtent = 32.0.obs;
  var cupertinolist = [
    {'ID': '-1', 'value': 'Seç'}
  ].obs;
  var cupertinolist2 = [
    {'ID': '-1', 'value': 'Seç'}
  ].obs;
  var cupertinolist3 = [
    {'ID': '-1', 'value': 'Seç'}
  ].obs;

  var selectedcupertinolist = 0.obs;
  var selectedcupertinolist2 = 0.obs;
  var selectedcupertinolist3 = 0.obs;

  var groupcreateProcess = false.obs;

  var isProcces = false.obs;

  late var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    user.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    groupcreaterequest("gruplar", cupertinolist);
    groupdetailfetch("E-spor", cupertinolist2);
    groupcreaterequest("E-spor", cupertinolist3);
  }

  Future<void> groupcreaterequest(
      String category, List<Map<String, String>> listname) async {
    FunctionsCategory f = FunctionsCategory(currentUser: user.value!);
    Map<String, dynamic> response = await f.category(category);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["kategori_ID"].toString(),
        'value': element["kategori_adi"]
      });
    }
  }

  Future<void> groupdetailfetch(
      String data, List<Map<String, String>> listname) async {
    FunctionsCategory f = FunctionsCategory(currentUser: user.value!);
    Map<String, dynamic> response = await f.categorydetail(data);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    listname.clear();
    for (dynamic element in response['icerik']) {
      listname.add({
        'ID': element["kategori_ID"].toString(),
        'value': element["kategori_adi"]
      });
    }
  }

  Future<void> creategroupfunction() async {
    if (groupcreateProcess.value) {
      return;
    }
    groupcreateProcess.value = true;

    FunctionsGroup f = FunctionsGroup(currentUser: user.value!);
    Map<String, dynamic> response = await f.groupcreate(
      groupname.value.text,
      groupshortname.value.text,
      selectedcupertinolist.value,
      selectedcupertinolist2.value,
      selectedcupertinolist3.value,
    );
    if (response["durum"] == 0) {
      String text = response["aciklama"];
      // if (mounted) {
      ARMOYUWidget.stackbarNotification(Get.context!, text);
      groupcreateProcess.value = false;
      // }

      return;
    }
    groupcreateProcess.value = false;
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

  var groupshortname = TextEditingController().obs;
  var groupname = TextEditingController().obs;
}
