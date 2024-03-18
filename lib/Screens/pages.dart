// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/app.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/Screens/Chat/chat_page.dart';

import 'package:ARMOYU/Core/AppCore.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  bool someCondition = false;
  bool siteMessagesProcces = false;
  @override
  void initState() {
    super.initState();
    cameratest();
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
    siteMessagesProcces = true;
    FunctionsApp f = FunctionsApp();
    Map<String, dynamic> response = await f.sitemesaji();

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    setState(() {
      ARMOYU.onlineMembersCount = response["icerik"]["cevrimicikac"];
      ARMOYU.totalPlayerCount = response["icerik"]["mevcutoyuncu"];
      ARMOYU.chatNotificationCount = response["icerik"]["sohbetbildirim"];
      ARMOYU.surveyNotificationCount = response["icerik"]["mevcutanket"];
      ARMOYU.eventsNotificationCount = response["icerik"]["mevcutetkinlik"];
      ARMOYU.downloadableCount = response["icerik"]["indirmeler"];

      ARMOYU.friendRequestCount = response["icerik"]["arkadaslikistekleri"];
      ARMOYU.GroupInviteCount = response["icerik"]["grupistekleri"];
    });

    siteMessagesProcces = false;
  }

  Future<void> cameratest() async {
    AppCore a = AppCore();

    if (a.getDevice() == "Android") {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        _cameras = await availableCameras();
        log(_cameras.toString());
      } on CameraException catch (e) {
        log(e.toString());
      }
    }
  }

  List<CameraDescription> _cameras = <CameraDescription>[];
// /////////////////////////////

  PageController pageController = PageController(initialPage: 0);
  void _changePage(int page) {
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
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
          // onPageChanged: (int page) {},
          controller: pageController,
          children: [
            MainPage(changePage: _changePage),
            const ChatPage(appbar: true),
          ],
        ),
      ),
    );
  }
}
