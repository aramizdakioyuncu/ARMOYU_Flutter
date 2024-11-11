import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/app.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagesController extends GetxController {
  final UserAccounts currentUserAccounts;
  PagesController({required this.currentUserAccounts});

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

    currentUserAccount = currentUserAccounts;

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
    } catch (e) {
      log("Ön Bellek Hatası: ${e.toString()}");
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
    FunctionsApp f = FunctionsApp(
      currentUser: currentUserAccount.user.value,
    );
    Map<String, dynamic> response = await f.sitemesaji();

    if (response["durum"] == 0) {
      if (response["aciklama"] == "Lütfen Geçerli API_KEY giriniz!") {
        someCondition.value = true;
        ARMOYUFunctions.updateForce(Get.context);
        return;
      }
      siteMessagesProcces.value = false;
      return;
    }

    try {
      ARMOYU.onlineMembersCount = response["icerik"]["cevrimicikac"];
      ARMOYU.totalPlayerCount = response["icerik"]["mevcutoyuncu"];
      currentUserAccount.chatNotificationCount =
          response["icerik"]["sohbetbildirim"];
      currentUserAccount.surveyNotificationCount =
          response["icerik"]["mevcutanket"];
      currentUserAccount.eventsNotificationCount =
          response["icerik"]["mevcutetkinlik"];
      currentUserAccount.downloadableCount = response["icerik"]["indirmeler"];

      currentUserAccount.friendRequestCount =
          response["icerik"]["arkadaslikistekleri"];
      currentUserAccount.groupInviteCount = response["icerik"]["grupistekleri"];
    } catch (e) {
      log(e.toString());
    }

    siteMessagesProcces.value = false;
  }
}
