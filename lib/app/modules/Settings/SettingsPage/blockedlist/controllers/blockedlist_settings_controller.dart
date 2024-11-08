import 'dart:developer';

import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/blocking.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedlistSettingsController extends GetxController {
  var blockedList = <Map<int, Widget>>[].obs;
  var blockedProcces = false.obs;
  var isFirstProcces = true.obs;
  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    if (isFirstProcces.value) {
      getblockedlist();
    }

    log(blockedList.length.toString());
  }

  Future<void> removeblock(int userID, int index) async {
    FunctionsBlocking f =
        FunctionsBlocking(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response = await f.remove(userID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    blockedList.removeWhere((element) => element.keys.first == userID);
  }

  Future<void> getblockedlist() async {
    if (blockedProcces.value) {
      return;
    }
    blockedProcces.value = true;
    FunctionsBlocking f =
        FunctionsBlocking(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response = await f.list();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      blockedProcces.value = false;
      isFirstProcces.value = false;
      return;
    }

    blockedList.clear();

    for (int i = 0; i < response['icerik'].length; i++) {
      int blockeduserID =
          int.parse(response['icerik'][i]["engel_kimeID"].toString());

      blockedList.add({
        blockeduserID: ListTile(
          leading: CircleAvatar(
            radius: 20,
            foregroundImage: CachedNetworkImageProvider(
                response['icerik'][i]["engel_avatar"].toString()),
          ),
          title: CustomText.costum1(
              response['icerik'][i]["engel_kime"].toString()),
          subtitle: Text(response['icerik'][i]["engel_kadi"].toString()),
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
              removeblock(blockeduserID, i);
            },
            child: Text(
              BlockedListKeys.unblock.tr,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
      });
    }
    blockedProcces.value = false;
    isFirstProcces.value = false;
  }
}
