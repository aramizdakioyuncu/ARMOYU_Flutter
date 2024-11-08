import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/devicepermission/controllers/devicepermission_settings_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class DevicepermissionsSettingsView extends StatelessWidget {
  const DevicepermissionsSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DevicepermissionSettingsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsKeys.devicePermissions.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Obx(
              () => Column(
                children: [
                  ListTile(
                    title: CustomText.costum1(
                        DevicePermissionKeys.deviceCamera.tr),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    onTap: () async {
                      if (controller.camPermission.value !=
                          DevicePermissionKeys.deviceDenied.tr) {
                        openAppSettings();
                        return;
                      }
                      PermissionStatus status =
                          await Permission.camera.request();
                      if (status.isGranted) {
                        controller.camPermissionCheck();
                      } else {
                        controller.camPermissionCheck();
                      }
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText.costum1(
                              controller.camPermission.value),
                        ),
                        const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(
                        DevicePermissionKeys.deviceContact.tr),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    onTap: () async {
                      if (controller.contactPermission.value !=
                          DevicePermissionKeys.deviceDenied.tr) {
                        openAppSettings();
                        return;
                      }
                      PermissionStatus status =
                          await Permission.contacts.request();
                      if (status.isGranted) {
                        controller.contactsPermissionCheck();
                      } else {
                        controller.contactsPermissionCheck();
                      }
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText.costum1(
                              controller.contactPermission.value),
                        ),
                        const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(
                        DevicePermissionKeys.deviceLocation.tr),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    onTap: () async {
                      if (controller.locationPermission.value !=
                          DevicePermissionKeys.deviceDenied.tr) {
                        openAppSettings();
                        return;
                      }
                      PermissionStatus status =
                          await Permission.locationWhenInUse.request();
                      if (status.isGranted) {
                        controller.locationPermissionCheck();
                      } else {
                        controller.locationPermissionCheck();
                      }
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText.costum1(
                              controller.locationPermission.value),
                        ),
                        const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(
                        DevicePermissionKeys.deviceMicrpohone.tr),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    onTap: () async {
                      if (controller.micPermission.value !=
                          DevicePermissionKeys.deviceDenied.tr) {
                        openAppSettings();
                        return;
                      }
                      PermissionStatus status =
                          await Permission.microphone.request();
                      if (status.isGranted) {
                        controller.micPermissionCheck();
                      } else {
                        controller.micPermissionCheck();
                      }
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText.costum1(
                              controller.micPermission.value),
                        ),
                        const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                  ListTile(
                    title: CustomText.costum1(
                        DevicePermissionKeys.deviceNotifications.tr),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    onTap: () async {
                      if (controller.notifiPermission.value !=
                          DevicePermissionKeys.deviceDenied.tr) {
                        openAppSettings();
                        return;
                      }
                      PermissionStatus status =
                          await Permission.notification.request();
                      if (status.isGranted) {
                        controller.notifiPermissionCheck();
                      } else {
                        controller.notifiPermissionCheck();
                      }
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText.costum1(
                              controller.notifiPermission.value),
                        ),
                        const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
