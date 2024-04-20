// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/app.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/Screens/Chat/chat_page.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

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

  void _timerFunction() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      siteMessage();
      // İstenilen koşula bağlı olarak timer'ı iptal etmek için bir örnek
      if (someCondition) {
        timer.cancel();
      }
    });
  }

  Future<void> siteMessage() async {
    if (siteMessagesProcces) {
      return;
    }

    if (ARMOYU.appUser.userID == null) {
      someCondition = true;
      return;
    }
    siteMessagesProcces = true;
    FunctionsApp f = FunctionsApp();
    Map<String, dynamic> response = await f.sitemesaji();

    if (response["durum"] == 0) {
      log(response["aciklama"]);

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
      setState(() {
        ARMOYU.onlineMembersCount = response["icerik"]["cevrimicikac"];
        ARMOYU.totalPlayerCount = response["icerik"]["mevcutoyuncu"];
        ARMOYU.chatNotificationCount = response["icerik"]["sohbetbildirim"];
        ARMOYU.surveyNotificationCount = response["icerik"]["mevcutanket"];
        ARMOYU.eventsNotificationCount = response["icerik"]["mevcutetkinlik"];
        ARMOYU.downloadableCount = response["icerik"]["indirmeler"];

        ARMOYU.friendRequestCount = response["icerik"]["arkadaslikistekleri"];
        ARMOYU.groupInviteCount = response["icerik"]["grupistekleri"];
      });
    } catch (e) {
      log(e.toString());
    }

    siteMessagesProcces = false;
  }

// /////////////////////////////

  PageController pageController = PageController(initialPage: 0);
  void changePage(int page) {
    setState(() {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
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
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MainPage(changePage: changePage),
            ChatPage(changePage: changePage),
          ],
        ),
      ),
    );
  }
}
