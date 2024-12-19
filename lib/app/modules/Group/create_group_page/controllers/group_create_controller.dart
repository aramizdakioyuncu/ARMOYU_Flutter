import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/category/category.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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
    CategoryResponse response =
        await API.service.categoryServices.category(categoryID: category);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    listname.clear();

    for (APICategory element in response.response!) {
      listname.add({
        'ID': element.categoryID.toString(),
        'value': element.name,
      });
    }
  }

  Future<void> groupdetailfetch(
      String data, List<Map<String, String>> listname) async {
    CategoryResponse response =
        await API.service.categoryServices.categorydetail(categoryID: data);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    listname.clear();
    for (APICategory element in response.response!) {
      listname.add({
        'ID': element.categoryID.toString(),
        'value': element.name,
      });
    }
  }

  Future<void> creategroupfunction() async {
    if (groupcreateProcess.value) {
      return;
    }
    groupcreateProcess.value = true;

    GroupCreateResponse response = await API.service.groupServices.groupcreate(
      grupadi: groupname.value.text,
      kisaltmaadi: groupshortname.value.text,
      grupkategori: selectedcupertinolist.value,
      grupkategoridetay: selectedcupertinolist2.value,
      varsayilanoyun: selectedcupertinolist3.value,
    );
    if (!response.result.status) {
      String text = response.result.description;
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
