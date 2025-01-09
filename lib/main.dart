import 'dart:io';

import 'package:ARMOYU/app/app.dart';
import 'package:ARMOYU/app/core/api.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Bellekteki verileri alıyoruz
  await GetStorage.init();

  //ARMOYU Service Setup
  API.service.setup();
  API.widgets;

  //Flutter Proje bilgisini çekiyoruz
  await getFlutterInfo();

  //Platform kontrolü yapıyoruz
  getPlatform();

  //Kameralar var mı diye kontrol
  ARMOYU.cameras = await availableCameras();

  //Cihaz Model yapıyoruz
  ARMOYU.deviceModel = await getdeviceModel();

  //Flutter Proje bilgisini çekiyoruz
  if (kDebugMode) {
    print("Cihaz Modeli: ${ARMOYU.deviceModel}");
    print("Platform: ${ARMOYU.devicePlatform}");
    print("Kameralar: ${ARMOYU.cameras!.length}");
    print("Proje Adı: ${ARMOYU.appName}");
    print("Proje Versiyon: ${ARMOYU.appVersion}");
    print("Proje Build: ${ARMOYU.appBuild}");
  }

  runApp(
    const Portal(
      child: MyApp(),
    ),
  );
}

getFlutterInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  ARMOYU.appName = packageInfo.appName;
  ARMOYU.appPackage = packageInfo.packageName;

  ARMOYU.appVersion = packageInfo.version;
  ARMOYU.appBuild = packageInfo.buildNumber;
}

Future<String> getdeviceModel() async {
  //Cihaz Kontrolü yaoıyoruz
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

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

getPlatform() {
  if (Platform.isAndroid) {
    ARMOYU.devicePlatform = "Android";
  } else if (Platform.isIOS) {
    ARMOYU.devicePlatform = "IOS";
  } else {
    ARMOYU.devicePlatform = "Bilinmeyen";
  }
}
