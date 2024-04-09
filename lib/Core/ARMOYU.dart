// ignore_for_file: deprecated_member_use, file_names

import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ARMOYU {
  static String appName = "";
  static String appPackage = "";
  static String appVersion = "";
  static String appBuild = "";

  static String securityDetail = "0";
  static String version = "";

  static String devicePlatform = "";
  static String deviceModel = "";

  static Color? appbarColor;
  static Color? appbottomColor;
  static Color? bodyColor;

  static Color? color;
  static Color? backgroundcolor;

  static Color? textColor;
  static Color? textbackColor;
  static Color? texthintColor;

  static Color? buttonColor;

  static double get screenWidth =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double get screenHeight =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

  static List<CameraDescription>? cameras;

  static User appUser = User();

  //Takım Seçme işlemleri
  static List<Team> favoriteteams = [];
  static Map<String, dynamic> favTeam = {};
  static bool favteamRequest = false;

  static int onlineMembersCount = 0;
  static int totalPlayerCount = 0;
  static int chatNotificationCount = 0;
  static int surveyNotificationCount = 0;
  static int eventsNotificationCount = 0;
  static int downloadableCount = 0;

  static int friendRequestCount = 0;
  static int groupInviteCount = 0;
}
