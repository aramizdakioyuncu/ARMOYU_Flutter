import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class AppCore {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Color? textColor;
  static Color? textbackColor;
  static Color? texthintColor;

  String getVersion() {
    return "1.0.0";
  }

  String getDevice() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "IOS";
    }
    return "Bilinmeyen";
  }

  Future<String> getDeviceModel() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print(androidInfo.model);
      return androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print(iosInfo.utsname.machine);
      return iosInfo.utsname.machine;
    }
    return "Bilinmeyen Cihaz";
  }

  static Future<List<XFile>> pickImages() async {
    final ImagePicker _picker = ImagePicker();
    List<XFile> images = await _picker.pickMultiImage();
    return images;
  }

  static Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<MultipartFile> generateImageFile(
      String text, XFile file) async {
    final fileBytes = await file.readAsBytes();
    return MultipartFile.fromBytes(text, fileBytes, filename: file.name);
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
