// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/Screens/Chat/chat_page.dart';
import 'package:ARMOYU/Services/User.dart';

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
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      print(_cameras);
    } on CameraException catch (e) {
      print(e);
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
    return Scaffold(
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
    );
  }
}
