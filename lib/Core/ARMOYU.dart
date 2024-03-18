// ignore_for_file: non_constant_identifier_names, deprecated_member_use, file_names

import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ARMOYU {
  static String Name = "0";
  static String SecurityDetail = "0";

  static Color? appbarColor;
  static Color? bodyColor;

  static Color? color;
  static Color? bacgroundcolor;

  static Color? textColor;
  static Color? textbackColor;
  static Color? texthintColor;

  static Color? buttonColor;

  static double get screenWidth =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double get screenHeight =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

  static List<CameraDescription>? cameras;

  static User Appuser = User();

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
  static int GroupInviteCount = 0;
}
