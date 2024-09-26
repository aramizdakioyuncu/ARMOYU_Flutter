// ignore_for_file: deprecated_member_use, file_names

import 'package:ARMOYU/app/data/models/ARMOYU/country.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ARMOYU {
  static String appName = "";
  static String appPackage = "";
  static String appVersion = "";
  static String appBuild = "";

  static String securityDetail = "0";
  static String version = "";

  static String devicePlatform = "";
  static String deviceModel = "";

  static Color appbarColor = Colors.black;
  static Color appbottomColor = Colors.black;
  static Color bodyColor = Colors.black;

  static Color color = Colors.black;
  static Color backgroundcolor = Colors.black;

  static Color textColor = Colors.black;
  static Color textbackColor = Colors.black;
  static Color texthintColor = Colors.black;

  static Color buttonColor = Colors.black;

  static Color baseColor = Colors.grey.shade300;
  static Color highlightColor = Colors.grey.shade100;

  static double get screenWidth =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double get screenHeight =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

  static List<CameraDescription>? cameras;

  static List<UserAccounts> appUsers = [];

  //Ülkeler ve Şehirler
  static List<Country> countryList = [];

  //Genel işlemler
  static int onlineMembersCount = 0;
  static int totalPlayerCount = 0;
}
