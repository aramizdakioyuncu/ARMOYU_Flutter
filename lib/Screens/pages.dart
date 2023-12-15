// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api

import 'dart:developer';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/Screens/Chat/chat_page.dart';
import 'package:ARMOYU/Services/User.dart';

import 'package:ARMOYU/Core/AppCore.dart';

class Pages extends StatefulWidget {
  @override
  _PagesState createState() => _PagesState();
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
    userID = User.ID;
    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;
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
        print(e);
      }
    }
  }

  List<CameraDescription> _cameras = <CameraDescription>[];
// /////////////////////////////

  PageController _pageController = PageController(initialPage: 0);
  void _changePage(int page) {
    setState(() {
      // _pageController.jumpToPage(page);
      _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
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
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Emin misiniz?'),
            content: Text('Uygulamadan çıkmak istiyor musunuz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Hayır'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Evet'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView(
          // physics: NeverScrollableScrollPhysics(), //kaydırma iptali
          onPageChanged: (int page) {},
          controller: _pageController,
          children: [
            MainPage(changePage: _changePage),
            ChatPage(appbar: true),
          ],
        ),
      ),
    );
  }
}
