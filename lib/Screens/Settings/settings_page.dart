import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
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
import 'package:ARMOYU/Widgets/Settings/listtile.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

TextEditingController _settingsController = TextEditingController();

class _SettingsPage extends State<SettingsPage> {
  List<Languange> languageList = [];

  final double _kItemExtent = 32.0;
  List<Map<String, String>> cupertinolist = [
    {'ID': '-1', 'value': 'Seç'}
  ];
  int _selectedcupertinolist = 0;

  List<WidgetSettings> listSettings = [];
  List<WidgetSettings> filteredlistSettings = [];

  List<WidgetSettings> listSettingssupport = [];
  List<WidgetSettings> filteredlistSettingssupport = [];

  Future<void> logoutfunction() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.logOut();
    ARMOYUWidget.toastNotification("r123");

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    passwordController.text = "";

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const LoginPage(),
      //   ),
      // );
    }
  }

  @override
  void initState() {
    super.initState();

    languageList.add(Languange(name: "Türkçe", binaryname: "TR"));
    languageList.add(Languange(name: "İngilizce", binaryname: "EN"));
    languageList.add(Languange(name: "Almanca", binaryname: "DE"));

    listSettings = [
      WidgetSettings(
        listtileIcon: Icons.phone_android_rounded,
        listtileTitle: "Cihaz İzinleri",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsDevicePermissionsPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.download_rounded,
        listtileTitle: "İndirme ve Arşivleme",
        tralingText: "Kapalı",
        onTap: () {},
      ),
      WidgetSettings(
        listtileIcon: Icons.network_wifi_3_bar_rounded,
        listtileTitle: "Veri Tasarrufu",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsDataSavingPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.language,
        listtileTitle: "Diller",
        tralingText: languageList[_selectedcupertinolist].name,
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
              children: List<Widget>.generate(languageList.length, (int index) {
                return Center(
                  child: CustomText.costum1(
                    languageList[index].name.toString(),
                  ),
                );
              }),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.notifications_active,
        listtileTitle: "Bildirimler",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsNotificationPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.block,
        listtileTitle: "Engellenenler",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsBlockeduserPage(),
            ),
          );
        },
      ),
    ];

    listSettingssupport = [
      WidgetSettings(
        listtileIcon: Icons.help,
        listtileTitle: "Yardım",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsHelpPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.person,
        listtileTitle: "Hesap Durumu",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsAccountStatusPage(),
            ),
          );
        },
      ),
      WidgetSettings(
        listtileIcon: Icons.info,
        listtileTitle: "Hakkında",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsAboutPage(),
            ),
          );
        },
      ),
    ];

    filteredlistSettings = listSettings;
    filteredlistSettingssupport = listSettingssupport;

    _settingsController.addListener(() {
      String newText = _settingsController.text.toLowerCase();
      // Filtreleme işlemi
      filteredlistSettings = listSettings.where((item) {
        return item.listtileTitle.toLowerCase().contains(newText);
      }).toList();
      // Filtreleme işlemi
      filteredlistSettingssupport = listSettingssupport.where((item) {
        return item.listtileTitle.toLowerCase().contains(newText);
      }).toList();

      if (mounted) {
        setState(() {});
      }
    });
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
          title: CustomText.costum1('Ayarlar'),
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
                      backgroundColor: Colors.transparent,
                      foregroundImage: CachedNetworkImageProvider(
                          ARMOYU.appUser.avatar!.mediaURL.minURL),
                      radius: 28,
                    ),
                    title: CustomText.costum1(ARMOYU.appUser.displayName!),
                    subtitle: CustomText.costum1(
                        "Hatalı Giriş: ${ARMOYU.appUser.lastfaillogin}"),
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
                        controller: _settingsController,
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
                  const SizedBox(height: 2.5),
                  Visibility(
                    visible: filteredlistSettings.isNotEmpty,
                    child: ListTile(
                      tileColor: ARMOYU.backgroundcolor,
                      title: CustomText.costum1("Uygulaman ve medya"),
                    ),
                  ),
                  Column(
                    children:
                        List.generate(filteredlistSettings.length, (index) {
                      return filteredlistSettings[index].listtile(context);
                    }),
                  ),
                  Visibility(
                    visible: filteredlistSettings.isNotEmpty,
                    child: Container(
                      color: ARMOYU.bodyColor,
                      height: 2.5,
                    ),
                  ),
                  Visibility(
                    visible: filteredlistSettingssupport.isNotEmpty,
                    child: ListTile(
                      tileColor: ARMOYU.backgroundcolor,
                      title: CustomText.costum1("Daha fazla bilgi ve destek"),
                    ),
                  ),
                  Column(
                    children: List.generate(filteredlistSettingssupport.length,
                        (index) {
                      return filteredlistSettingssupport[index]
                          .listtile(context);
                    }),
                  ),
                  Visibility(
                    visible: filteredlistSettingssupport.isNotEmpty,
                    child: Container(
                      color: ARMOYU.bodyColor,
                      height: 2.5,
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        tileColor: ARMOYU.backgroundcolor,
                        title: CustomText.costum1(
                          "Hesap Ekle",
                          color: Colors.blue,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        tileColor: ARMOYU.backgroundcolor,
                        title: CustomText.costum1(
                          "Çıkış Yap",
                          color: Colors.red,
                        ),
                        onTap: () => logoutfunction(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomText.costum1(
                        "Versiyon : ${ARMOYU.appVersion.toString()} (${ARMOYU.appBuild.toString()})"),
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
