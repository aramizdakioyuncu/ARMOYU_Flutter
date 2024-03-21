import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsDevicePermissionsPage extends StatefulWidget {
  const SettingsDevicePermissionsPage({super.key});

  @override
  State<SettingsDevicePermissionsPage> createState() =>
      _SettingsDevicePermissionsPage();
}

class _SettingsDevicePermissionsPage
    extends State<SettingsDevicePermissionsPage> {
  String micPermission = "İzin verilmedi";
  String locationPermission = "İzin verilmedi";
  String camPermission = "İzin verilmedi";
  String contactPermission = "İzin verilmedi";
  String notifiPermission = "İzin verilmedi";

  @override
  void initState() {
    super.initState();
    camPermissionCheck();
    micPermissionCheck();
    locationPermissionCheck();
    contactsPermissionCheck();
    notifiPermissionCheck();
  }

  Future<void> camPermissionCheck() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        camPermission = "İzin verildi";
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        camPermission = "Kalıcı olarak verilmedi";
      });
    }
  }

  Future<void> micPermissionCheck() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      setState(() {
        micPermission = "İzin verildi";
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        micPermission = "Kalıcı olarak verilmedi";
      });
    }
  }

  Future<void> locationPermissionCheck() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      setState(() {
        locationPermission = "İzin verildi";
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        locationPermission = "Kalıcı olarak verilmedi";
      });
    }
  }

  Future<void> contactsPermissionCheck() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      setState(() {
        contactPermission = "İzin verildi";
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        contactPermission = "Kalıcı olarak verilmedi";
      });
    }
  }

  Future<void> notifiPermissionCheck() async {
    var status = await Permission.notification.status;
    log(status.isGranted.toString());

    if (status.isGranted) {
      log(status.isGranted.toString());
      setState(() {
        notifiPermission = "İzin verildi";
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        notifiPermission = "Kalıcı olarak verilmedi";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text('Cihaz İzinleri'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1("Kamera"),
                  tileColor: ARMOYU.backgroundcolor,
                  onTap: () async {
                    if (camPermission != "İzin verilmedi") {
                      openAppSettings();
                      return;
                    }
                    PermissionStatus status = await Permission.camera.request();
                    if (status.isGranted) {
                      camPermissionCheck();
                    } else {
                      camPermissionCheck();
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText.costum1(camPermission),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Kişiler"),
                  tileColor: ARMOYU.backgroundcolor,
                  onTap: () async {
                    if (contactPermission != "İzin verilmedi") {
                      openAppSettings();
                      return;
                    }
                    PermissionStatus status =
                        await Permission.contacts.request();
                    if (status.isGranted) {
                      contactsPermissionCheck();
                    } else {
                      contactsPermissionCheck();
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText.costum1(contactPermission),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Konum"),
                  tileColor: ARMOYU.backgroundcolor,
                  onTap: () async {
                    if (locationPermission != "İzin verilmedi") {
                      openAppSettings();
                      return;
                    }
                    PermissionStatus status =
                        await Permission.locationWhenInUse.request();
                    if (status.isGranted) {
                      locationPermissionCheck();
                    } else {
                      locationPermissionCheck();
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText.costum1(locationPermission),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Mikrofon"),
                  tileColor: ARMOYU.backgroundcolor,
                  onTap: () async {
                    if (micPermission != "İzin verilmedi") {
                      openAppSettings();
                      return;
                    }
                    PermissionStatus status =
                        await Permission.microphone.request();
                    if (status.isGranted) {
                      micPermissionCheck();
                    } else {
                      micPermissionCheck();
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText.costum1(micPermission),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1("Bildirimler"),
                  tileColor: ARMOYU.backgroundcolor,
                  onTap: () async {
                    if (micPermission != "İzin verilmedi") {
                      openAppSettings();
                      return;
                    }
                    PermissionStatus status =
                        await Permission.notification.request();
                    if (status.isGranted) {
                      notifiPermissionCheck();
                    } else {
                      notifiPermissionCheck();
                    }
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText.costum1(notifiPermission),
                      ),
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
