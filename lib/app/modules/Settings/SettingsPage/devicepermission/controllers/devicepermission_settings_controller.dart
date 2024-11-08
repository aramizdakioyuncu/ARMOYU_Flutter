import 'dart:developer';

import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class DevicepermissionSettingsController extends GetxController {
  var micPermission = (DevicePermissionKeys.deviceDenied.tr).obs;
  var locationPermission = (DevicePermissionKeys.deviceDenied.tr).obs;
  var camPermission = (DevicePermissionKeys.deviceDenied.tr).obs;
  var contactPermission = (DevicePermissionKeys.deviceDenied.tr).obs;
  var notifiPermission = (DevicePermissionKeys.deviceDenied.tr).obs;

  @override
  void onInit() {
    super.onInit();
    camPermissionCheck();
    micPermissionCheck();
    locationPermissionCheck();
    contactsPermissionCheck();
    notifiPermissionCheck();
  }

  Future<void> camPermissionCheck() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      camPermission.value = DevicePermissionKeys.deviceGranted.tr;
    } else if (status.isPermanentlyDenied) {
      camPermission.value = DevicePermissionKeys.devicePermanentlyDenied.tr;
    }
  }

  Future<void> micPermissionCheck() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      micPermission.value = DevicePermissionKeys.deviceGranted.tr;
    } else if (status.isPermanentlyDenied) {
      micPermission.value = DevicePermissionKeys.devicePermanentlyDenied.tr;
    }
  }

  Future<void> locationPermissionCheck() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      locationPermission.value = DevicePermissionKeys.deviceGranted.tr;
    } else if (status.isPermanentlyDenied) {
      locationPermission.value =
          DevicePermissionKeys.devicePermanentlyDenied.tr;
    }
  }

  Future<void> contactsPermissionCheck() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      contactPermission.value = DevicePermissionKeys.deviceGranted.tr;
    } else if (status.isPermanentlyDenied) {
      contactPermission.value = DevicePermissionKeys.devicePermanentlyDenied.tr;
    }
  }

  Future<void> notifiPermissionCheck() async {
    var status = await Permission.notification.status;
    log(status.isGranted.toString());

    if (status.isGranted) {
      log(status.isGranted.toString());
      notifiPermission.value = DevicePermissionKeys.deviceGranted.tr;
    } else if (status.isPermanentlyDenied) {
      notifiPermission.value = DevicePermissionKeys.devicePermanentlyDenied.tr;
    }
  }
}
