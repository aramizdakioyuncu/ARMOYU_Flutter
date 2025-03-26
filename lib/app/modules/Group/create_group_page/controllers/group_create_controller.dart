import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/core/widgets.dart';
import 'package:armoyu_widgets/data/models/select.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/category/category.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GroupCreateController extends GetxController {
  Rx<Selection> groupcategoryList = Rx(Selection(list: []));

  var groupcategory = Rxn<String>(null);
  var groupcategorydetail = Rxn<String>(null);
  var groupmaingamedetail = Rxn<String>(null);

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

    groupcreaterequest("gruplar", groupcategoryList);
  }

  Future<void> groupcreaterequest(String category, Rx<Selection>? listname,
      {bool restartfetch = false}) async {
    // if (!restartfetch && listname!.value.list != null) {
    //   return;
    // }
    CategoryResponse response =
        await API.service.categoryServices.category(categoryID: category);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }
    listname ??= Rx(Selection(list: []));

    listname.value = Selection(list: []);
    for (APICategory element in response.response!) {
      listname.value.list!.add(
        Select(
          selectID: element.categoryID,
          title: element.name,
          value: element.name,
          selectionList: Rx(
            Selection(list: []),
          ),
        ),
      );
    }
  }

  Future<void> groupdetailfetch(String data, Rx<Selection>? listname,
      {bool restartfetch = false}) async {
    // if (!restartfetch && listname!.value.list != null) {
    //   return;
    // }

    CategoryResponse response =
        await API.service.categoryServices.categorydetail(categoryID: data);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    listname!.value = Selection(list: []);

    for (APICategory element in response.response!) {
      listname.value.list!.add(
        Select(
          selectID: element.categoryID,
          title: element.name,
          value: element.name,
          selectionList: Rx(
            Selection(list: []),
          ),
        ),
      );
    }

    log(listname.value.list!.length.toString());
  }

  Future<void> creategroupfunction() async {
    if (groupcreateProcess.value) {
      return;
    }
    groupcreateProcess.value = true;

    try {
      int number1 = groupcategoryList.value.selectedIndex!.value!;

      int number2 = groupcategoryList
          .value.list![number1].selectionList!.value.selectedIndex!.value!;

      int number3 = groupcategoryList.value.list![number1].selectionList!.value
          .list![number2].selectionList!.value.selectedIndex!.value!;

      Select select1 = groupcategoryList.value.list![number1 + 1];
      Select select2 = groupcategoryList
          .value.list![number1].selectionList!.value.list![number2];
      Select select3 = groupcategoryList.value.list![number1].selectionList!
          .value.list![number2].selectionList!.value.list![number3];

      log(groupname.value.text);
      log(groupshortname.value.text);
      log("${select1.selectID} ${select1.title}");
      log(select2.selectID.toString());
      log(select3.selectID.toString());

      GroupCreateResponse response =
          await API.service.groupServices.groupcreate(
        grupadi: groupname.value.text,
        kisaltmaadi: groupshortname.value.text,
        grupkategori: select1.selectID,
        grupkategoridetay: select2.selectID,
        varsayilanoyun: select3.selectID,
      );

      String text = response.result.description;

      ARMOYUWidget.toastNotification(text);
      groupcreateProcess.value = false;

      Get.back();
    } catch (e) {
      log(e.toString());
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
