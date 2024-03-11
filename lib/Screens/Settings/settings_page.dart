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
import 'package:ARMOYU/Services/appuser.dart';
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
                    tileColor: ARMOYU.bacgroundcolor,
                    leading: CircleAvatar(
                      foregroundImage:
                          CachedNetworkImageProvider(AppUser.avatar),
                      radius: 28,
                    ),
                    title: Text(AppUser.displayName),
                    subtitle:
                        CustomText().costum1("Son Hatalı Giriş: 20.02.2002"),
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
                      height: 40,
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
                            size: 12,
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
                        tileColor: ARMOYU.bacgroundcolor,
                        title: const Text("Uygulaman ve medya"),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.phone_android_rounded,
                        ),
                        title: CustomText().costum1("Cihaz İzinleri"),
                        tileColor: ARMOYU.bacgroundcolor,
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
                        title: CustomText().costum1("İndirme ve Arşivleme"),
                        tileColor: ARMOYU.bacgroundcolor,
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
                        title: CustomText().costum1("Veri Tasarrufu"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsDataSavingPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.bacgroundcolor,
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_forward_ios_outlined, size: 17),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: CustomText().costum1("Diller"),
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
                        tileColor: ARMOYU.bacgroundcolor,
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
                    title: CustomText().costum1("Bildirimler"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SettingsNotificationPage(),
                        ),
                      );
                    },
                    tileColor: ARMOYU.bacgroundcolor,
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: CustomText().costum1("Engellenenler"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsBlockeduserPage(),
                        ),
                      );
                    },
                    tileColor: ARMOYU.bacgroundcolor,
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
                        tileColor: ARMOYU.bacgroundcolor,
                        title: const Text("Daha fazla bilgi ve destek"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: CustomText().costum1("Yardım"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsHelpPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.bacgroundcolor,
                        trailing: const Icon(Icons.arrow_forward_ios_outlined,
                            size: 17),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: CustomText().costum1("Hesap Durumu"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsAccountStatusPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.bacgroundcolor,
                        trailing: const Icon(Icons.arrow_forward_ios_outlined,
                            size: 17),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: CustomText().costum1("Hakkında"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsAboutPage(),
                            ),
                          );
                        },
                        tileColor: ARMOYU.bacgroundcolor,
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
                        tileColor: ARMOYU.bacgroundcolor,
                        title: const Text("Hesap Ekle"),
                        onTap: () async {},
                      ),
                      ListTile(
                        textColor: Colors.red,
                        iconColor: Colors.red,
                        tileColor: ARMOYU.bacgroundcolor,
                        title: const Text("Çıkış Yap"),
                        onTap: () async {
                          FunctionService f = FunctionService();
                          Map<String, dynamic> response = await f.logOut();

                          if (response["durum"] == 0) {
                            log(response["aciklama"]);
                            return;
                          }
                          passwordController.text = "";
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
