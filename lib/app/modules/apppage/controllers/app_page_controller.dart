import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/pages/_main/views/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPageController extends GetxController {
  late UserAccounts currentUserAccounts;
  var pagesViewList = <Pages>[].obs; // Reaktif liste
  var pagesController = PageController(initialPage: 0).obs;

  @override
  void onInit() {
    super.onInit();

    // Tüm hesapları aktif et
    for (var element in ARMOYU.appUsers) {
      pagesViewList.add(
        Pages(
          currentUserAccounts: element,
        ),
      );
    }

    for (Pages pagaviewInfo in pagesViewList) {
      log("${pagaviewInfo.currentUserAccounts.user.userID!} -> ${pagaviewInfo.currentUserAccounts.user.displayName!}");
    }
  }

  Future<void> changeAccount(UserAccounts selectedUser) async {
    if (!pagesViewList.any((element) =>
        element.currentUserAccounts.user.userID! ==
        selectedUser.user.userID!)) {
      pagesViewList.add(
        Pages(
          currentUserAccounts: selectedUser,
        ),
      );
      log("Aktif Hesap Sayısı:${pagesViewList.length - 1} -> ${pagesViewList.length}");
      update();
    } else {
      log("Aktif Hesap Sayısı: ${pagesViewList.length}");
    }

    int countPageIndex = pagesViewList.indexWhere((element) =>
        element.currentUserAccounts.user.userID == selectedUser.user.userID);

    log("Index Sayaç $countPageIndex");

    Get.back();

    pagesController.value.animateToPage(
      countPageIndex,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.ease,
    );

    await fetchChangedprofiledata(selectedUser.user);
  }

  Future<void> fetchChangedprofiledata(User user) async {
    FunctionService f = FunctionService(currentUser: user);

    try {
      User? userInfo = await f.fetchUserInfo(userID: user.userID!);
      if (userInfo != null) {
        userInfo.password = user.password;
        userInfo.updateUser(targetUser: user);
      } else {
        log("Kullanıcı bilgileri alınamadı.");
        // Kullanıcıya hata mesajı göster
      }
    } catch (e) {
      log("Hata: $e");
      // Hata mesajı göster
    }
  }
}
