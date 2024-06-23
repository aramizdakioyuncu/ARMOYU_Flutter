// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/app.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/Screens/Chat/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pages extends StatefulWidget {
  final User currentUser;
  final Function changeProfileFunction;
  const Pages({
    super.key,
    required this.currentUser,
    required this.changeProfileFunction,
  });

  @override
  State<Pages> createState() => _PagesState();
}

bool someCondition = false;
bool siteMessagesProcces = false;

class _PagesState extends State<Pages> {
  @override
  void initState() {
    super.initState();

    siteMessage();
    _timerFunction();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    someCondition = true;
  }

  void _timerFunction() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      //Önbelleğe al
      saveCacheData();
      //Site Mesajı Kontrolü yap
      siteMessage();
      // İstenilen koşula bağlı olarak timer'ı iptal etmek için bir örnek
      if (someCondition) {
        timer.cancel();
      }
    });
  }

  Future<void> saveCacheData() async {
    // Kullanıcı listesini SharedPreferences'e kaydetme
    log("-> Önbellekleme İşlemi");
    final prefs = await SharedPreferences.getInstance();
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    prefs.setStringList('users', usersJson);
    //
  }

  Future<void> siteMessage() async {
    if (siteMessagesProcces) {
      return;
    }

    if (widget.currentUser.userID == null) {
      someCondition = true;
      return;
    }
    siteMessagesProcces = true;
    FunctionsApp f = FunctionsApp(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.sitemesaji();

    if (response["durum"] == 0) {
      if (response["aciklama"] == "Lütfen Geçerli API_KEY giriniz!") {
        if (mounted) {
          someCondition = true;
          ARMOYUFunctions.updateForce(context);
        }
        return;
      }
      siteMessagesProcces = false;
      return;
    }

    try {
      ARMOYU.onlineMembersCount = response["icerik"]["cevrimicikac"];
      ARMOYU.totalPlayerCount = response["icerik"]["mevcutoyuncu"];
      ARMOYU.chatNotificationCount = response["icerik"]["sohbetbildirim"];
      ARMOYU.surveyNotificationCount = response["icerik"]["mevcutanket"];
      ARMOYU.eventsNotificationCount = response["icerik"]["mevcutetkinlik"];
      ARMOYU.downloadableCount = response["icerik"]["indirmeler"];

      ARMOYU.friendRequestCount = response["icerik"]["arkadaslikistekleri"];
      ARMOYU.groupInviteCount = response["icerik"]["grupistekleri"];
    } catch (e) {
      log(e.toString());
    }

    siteMessagesProcces = false;
    setstatefunction();
  }

// /////////////////////////////

  final PageController _pageController = PageController(initialPage: 0);

  void changePage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında yapılacak işlemler
        changePage(0);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MainPage(
              currentUser: widget.currentUser,
              changePage: changePage,
              changeProfileFunction: widget.changeProfileFunction,
            ),
            ChatPage(currentUser: widget.currentUser, changePage: changePage),
          ],
        ),
      ),
    );
  }
}
