import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/blocking/blocking_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedlistSettingsController extends GetxController {
  var blockedList = <Map<int, Widget>>[].obs;
  var blockedProcces = false.obs;
  var isFirstProcces = true.obs;
  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    if (isFirstProcces.value) {
      getblockedlist();
    }

    log(blockedList.length.toString());
  }

  Future<void> removeblock(int userID, int index) async {
    // FunctionsBlocking f =
    //     FunctionsBlocking(currentUser: currentUserAccounts.value.user.value);

    BlockingRemoveResponse response =
        await API.service.blockingServices.remove(userID: userID);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }
    blockedList.removeWhere((element) => element.keys.first == userID);
  }

  Future<void> getblockedlist() async {
    if (blockedProcces.value) {
      return;
    }
    blockedProcces.value = true;

    BlockingListResponse response = await API.service.blockingServices.list();
    if (!response.result.status) {
      log(response.result.description);
      blockedProcces.value = false;
      isFirstProcces.value = false;
      return;
    }

    blockedList.clear();

    int orderCount = 0;
    for (APIBlockingList element in response.response!) {
      int blockeduserID = element.blockeduser.userID;
      blockedList.add({
        blockeduserID: ListTile(
          leading: CircleAvatar(
            radius: 20,
            foregroundImage: CachedNetworkImageProvider(
              element.blockeduser.avatar.minURL,
            ),
          ),
          title: CustomText.costum1(element.blockeduser.displayname),
          subtitle: Text(element.blockeduser.username!),
          onTap: () {},
          trailing: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
            onPressed: () async {
              removeblock(blockeduserID, orderCount);
            },
            child: Text(
              BlockedListKeys.unblock.tr,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      });
      orderCount++;
    }
    blockedProcces.value = false;
    isFirstProcces.value = false;
  }
}
