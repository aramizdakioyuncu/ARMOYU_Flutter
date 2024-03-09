// ignore_for_file: deprecated_member_use

import 'dart:developer';

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
  @override
  void initState() {
    super.initState();
    cameratest();
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
