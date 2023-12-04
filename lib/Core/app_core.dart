import 'package:device_info/device_info.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class AppCore {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

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
}
