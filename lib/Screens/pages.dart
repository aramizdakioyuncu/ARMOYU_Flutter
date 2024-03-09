// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/Screens/Chat/chat_page.dart';
import 'package:ARMOYU/Services/appuser.dart';

import 'package:ARMOYU/Core/AppCore.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int userID = -1;
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';

  @override
  void initState() {
    super.initState();
    userID = AppUser.ID;
    userName = AppUser.displayName;
    userEmail = AppUser.mail;
    useravatar = AppUser.avatar;
    userbanner = AppUser.banneravatar;
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
      // _pageController.jumpToPage(page);
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
        // Örneğin, bir dialog göstermek istiyorsanız:

        return false;
        // return await showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Emin misiniz?'),
        //     content: Text('Uygulamadan çıkmak istiyor musunuz?'),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.of(context).pop(false),
        //         child: Text('Hayır'),
        //       ),
        //       TextButton(
        //         onPressed: () => Navigator.of(context).pop(true),
        //         child: Text('Evet'),
        //       ),
        //     ],
        //   ),
        // );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
          // physics: NeverScrollableScrollPhysics(), //kaydırma iptali
          onPageChanged: (int page) {},
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
