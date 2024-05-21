// ignore_for_file: deprecated_member_use, file_names

import 'package:ARMOYU/Models/ARMOYU/country.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Models/user.dart';
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

  static double get screenWidth =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double get screenHeight =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

  static List<CameraDescription>? cameras;

  // static User appUser = User();

  static List<User> appUsers = [];
  static int selectedUser = 0;
  // static User currentUser = appUsers[selectedUser];

  //Takım Seçme işlemleri
  static List<Team> favoriteteams = [];
  static Map<String, dynamic> favTeam = {};
  static bool favteamRequest = false;

  //Ülkeler ve Şehirler
  static List<Country> countryList = [];

  //Genel işlemler
  static int onlineMembersCount = 0;
  static int totalPlayerCount = 0;
  static int chatNotificationCount = 0;
  static int surveyNotificationCount = 0;
  static int eventsNotificationCount = 0;
  static int downloadableCount = 0;

  static int friendRequestCount = 0;
  static int groupInviteCount = 0;

  // //Gruplarım & Okullarım & İşyerlerim
  // static List<Group> myGroups = [];
  // static List<School> mySchools = [];
  // static List<Station> myStations = [];

  // //Arkadaşlarım
  // static List<User> myFriends = [];
  // static List<User> mycloseFriends = [];
}
