import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/_main/views/pages_view.dart';
import 'package:armoyu_services/armoyu_services.dart';
import 'package:armoyu_widgets/functions/functions_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPageController extends GetxController {
  late UserAccounts currentUserAccounts;
  var pagesViewList = <PagesView>[].obs; // Reaktif liste
  var pagesController = PageController(initialPage: 0).obs;

  @override
  void onInit() {
    super.onInit();
    // Tüm hesapları aktif et
    // for (var element in ARMOYU.appUsers) {
    //   pagesViewList.add(const PagesView());
    // }
    pagesViewList.addAll(
        List.generate(ARMOYU.appUsers.length, (_) => const PagesView()));

    // for (PagesView pagaviewInfo in pagesViewList) {
    //   log("${pagaviewInfo.currentUserAccounts.user.value.userID!} -> ${pagaviewInfo.currentUserAccounts.user.value.displayName!}");
    // }
  }

  Future<void> changeAccount(UserAccounts selectedUser) async {
    // if (!pagesViewList.any(
    //   (element) =>
    //       element.currentUserAccounts.user.value.userID! ==
    //       selectedUser.user.value.userID!,
    // )) {
    //   pagesViewList.add(const PagesView());

    //   log("Aktif Hesap Sayısı:${pagesViewList.length - 1} -> ${pagesViewList.length}");
    //   update();
    // } else {
    //   log("Aktif Hesap Sayısı: ${pagesViewList.length}");
    // }

    // int countPageIndex = pagesViewList.indexWhere(
    //   (element) =>
    //       element.currentUserAccounts.user.value.userID ==
    //       selectedUser.user.value.userID,
    // );

    // log("Index Sayaç $countPageIndex");

    // Get.back();

    // final accountController = Get.find<AccountUserController>();
    // accountController.changeUser(UserAccounts(user: selectedUser.user));

    // pagesController.value.animateToPage(
    //   countPageIndex,
    //   duration: const Duration(
    //     milliseconds: 300,
    //   ),
    //   curve: Curves.ease,
    // );

    // await fetchChangedprofiledata(selectedUser.user.value);
  }

  Future<void> fetchChangedprofiledata(User user) async {
    FunctionService f = FunctionService(API.service);

    try {
      User? userInfo = await f.fetchUserInfo(userID: user.userID!);
      if (userInfo != null) {
        // userInfo.sesssionTOKEN = user.sesssionTOKEN;
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
