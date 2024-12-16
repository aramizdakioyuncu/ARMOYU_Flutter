import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagesController extends GetxController {
  late UserAccounts currentUserAccount;

  var someCondition = false.obs;
  var siteMessagesProcces = false.obs;

  var pageController = PageController(initialPage: 0);

  void changePage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    currentUserAccount = findCurrentAccountController.currentUserAccounts.value;

    //Önbellek İşlemleri
    siteMessage();
    timerFunction();
  }

  @override
  void dispose() {
    super.dispose();
    someCondition.value = true;
  }

  void timerFunction() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      //Önbelleğe al
      saveCacheData();
      //Site Mesajı Kontrolü yap
      siteMessage();
      // İstenilen koşula bağlı olarak timer'ı iptal etmek için bir örnek
      if (someCondition.value) {
        timer.cancel();
      }
    });
  }

  Future<void> saveCacheData() async {
    // Kullanıcı listesini SharedPreferences'e kaydetme
    log("-> Önbellekleme İşlemi");
    final prefs = await SharedPreferences.getInstance();

    try {
      List<String> usersJson =
          ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
      prefs.setStringList('users', usersJson);
      log("-> Önbellekleme İşlemi -- <<TAMAMLANDI>>");
    } catch (e) {
      log("-> Önbellekleme HATASI HATASI HATASI");
      log(e.toString());
    }

    //
  }

  Future<void> siteMessage() async {
    if (siteMessagesProcces.value) {
      return;
    }

    if (currentUserAccount.user.value.userID == null) {
      someCondition.value = true;
      return;
    }
    siteMessagesProcces.value = true;

    SitemessageResponse response = await API.service.appServices.sitemesaji();

    if (!response.result.status) {
      if (response.result.description == "Lütfen Geçerli API_KEY giriniz!") {
        someCondition.value = true;
        ARMOYUFunctions.updateForce(Get.context);
        return;
      }
      siteMessagesProcces.value = false;
      return;
    }

    try {
      ARMOYU.onlineMembersCount = response.response!.onlineMembers;
      ARMOYU.totalPlayerCount = response.response!.currentMembers;
      currentUserAccount.chatNotificationCount.value =
          response.response!.chatcount;
      currentUserAccount.surveyNotificationCount.value =
          response.response!.avaiblepolls;
      currentUserAccount.eventsNotificationCount.value =
          response.response!.avaibleEvents;
      currentUserAccount.downloadableCount.value = response.response!.downloads;

      currentUserAccount.friendRequestCount.value =
          response.response!.friendrequests;
      currentUserAccount.groupInviteCount.value =
          response.response!.grouprequests;
    } catch (e) {
      log(e.toString());
    }

    siteMessagesProcces.value = false;
  }
}
