// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Models/language.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/Account/accountsettings.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/aboutsettings.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/accountstatussettings.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/blockedusersettings.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/datasavingsetting.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/devicepermissions.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/helpsettings.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/notificationsetttings.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  List<Languange> languageList = [];

  final double _kItemExtent = 32.0;
  List<Map<String, String>> cupertinolist = [
    {'ID': '-1', 'value': 'Seç'}
  ];
  int _selectedcupertinolist = 0;

  @override
  void initState() {
    super.initState();

    languageList.add(Languange(name: "Türkçe", binaryname: "TR"));

    languageList.add(Languange(name: "İngilizce", binaryname: "EN"));

    languageList.add(Languange(name: "Almanca", binaryname: "DE"));
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.appbarColor,
        appBar: AppBar(
          title: const Text('Ayarlar'),
          backgroundColor: ARMOYU.appbarColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(color: ARMOYU.bodyColor, height: 1),
                  ListTile(
                    tileColor: ARMOYU.backgroundcolor,
                    leading: CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                          ARMOYU.Appuser.avatar!.mediaURL.minURL),
                      radius: 28,
                    ),
                    title: Text(ARMOYU.Appuser.displayName!),
                    subtitle: CustomText.costum1(
                        "Hatalı Giriş: ${ARMOYU.Appuser.lastfaillogin}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsAccountPage(),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.qr_code),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: ARMOYU.bodyColor,
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                          ),
                          hintText: 'Ara',
                        ),
                        style: TextStyle(
                          color: ARMOYU.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Container(color: ARMOYU.bodyColor, height: 5),
                  Column(
                    children: [
                      ListTile(
                        tileColor: ARMOYU.backgroundcolor,
                        title: const Text("Uygulaman ve medya"),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.phone_android_rounded,
                        ),
                        title: CustomText.costum1("Cihaz İzinleri"),
                        tileColor: ARMOYU.backgroundcolor,
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_forward_ios_outlined, size: 17),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsDevicePermissionsPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.download_rounded,
                        ),
                        title: CustomText.costum1("İndirme ve Arşivleme"),
                        tileColor: ARMOYU.backgroundcolor,
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Kapalı'),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined, size: 17),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.network_wifi_3_bar_rounded,
                        ),
                        title: CustomText.costum1("Veri Tasarrufu"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsDataSavingPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.backgroundcolor,
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_forward_ios_outlined, size: 17),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: CustomText.costum1("Diller"),
                        onTap: () {
                          _showDialog(
                            CupertinoPicker(
                              magnification: 1.22,
                              squeeze: 1.2,
                              useMagnifier: true,
                              itemExtent: _kItemExtent,
                              scrollController: FixedExtentScrollController(
                                initialItem: _selectedcupertinolist,
                              ),
                              onSelectedItemChanged: (int selectedItem) async {
                                setState(() {
                                  _selectedcupertinolist = selectedItem;
                                });
                              },
                              children: List<Widget>.generate(
                                  languageList.length, (int index) {
                                return Center(
                                    child: Text(
                                        languageList[index].name.toString()));
                              }),
                            ),
                          );
                        },
                        tileColor: ARMOYU.backgroundcolor,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  languageList[_selectedcupertinolist].name),
                            ),
                            const Icon(Icons.arrow_forward_ios_outlined,
                                size: 17),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_active),
                    title: CustomText.costum1("Bildirimler"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SettingsNotificationPage(),
                        ),
                      );
                    },
                    tileColor: ARMOYU.backgroundcolor,
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: CustomText.costum1("Engellenenler"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsBlockeduserPage(),
                        ),
                      );
                    },
                    tileColor: ARMOYU.backgroundcolor,
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                  Container(color: ARMOYU.bodyColor, height: 5),
                  Column(
                    children: [
                      ListTile(
                        tileColor: ARMOYU.backgroundcolor,
                        title: const Text("Daha fazla bilgi ve destek"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: CustomText.costum1("Yardım"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsHelpPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.backgroundcolor,
                        trailing: const Icon(Icons.arrow_forward_ios_outlined,
                            size: 17),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: CustomText.costum1("Hesap Durumu"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsAccountStatusPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.backgroundcolor,
                        trailing: const Icon(Icons.arrow_forward_ios_outlined,
                            size: 17),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: CustomText.costum1("Hakkında"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsAboutPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.backgroundcolor,
                        trailing: const Icon(Icons.arrow_forward_ios_outlined,
                            size: 17),
                      ),
                    ],
                  ),
                  Container(color: ARMOYU.bodyColor, height: 5),
                  Column(
                    children: [
                      ListTile(
                        textColor: Colors.blue,
                        iconColor: Colors.blue,
                        tileColor: ARMOYU.backgroundcolor,
                        title: const Text("Hesap Ekle"),
                        onTap: () async {},
                      ),
                      ListTile(
                        textColor: Colors.red,
                        iconColor: Colors.red,
                        tileColor: ARMOYU.backgroundcolor,
                        title: const Text("Çıkış Yap"),
                        onTap: () async {
                          FunctionService f = FunctionService();
                          Map<String, dynamic> response = await f.logOut();

                          if (response["durum"] == 0) {
                            log(response["aciklama"]);
                            return;
                          }
                          passwordController.text = "";

                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Text(
                      "Versiyon : ${ARMOYU.appVersion.toString()} (${ARMOYU.appBuild.toString()})"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
