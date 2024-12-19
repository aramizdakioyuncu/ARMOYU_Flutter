import 'package:ARMOYU/app/data/models/ARMOYU/country.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ARMOYU {
  static String appName = "";
  static String appPackage = "";
  static String appVersion = "";
  static String appBuild = "";

  static String securityDetail = "0";
  static String version = "";

  static String devicePlatform = "";
  static String deviceModel = "";

  static double get screenWidth => Get.width;
  static double get screenHeight => Get.height;

  static List<CameraDescription>? cameras;

  static var appUsers = <UserAccounts>[].obs;

  //Ülkeler ve Şehirler
  static List<Country> countryList = [];

  //Genel işlemler
  static int onlineMembersCount = 0;
  static int totalPlayerCount = 0;

  static GetStorage storage = GetStorage();
}
