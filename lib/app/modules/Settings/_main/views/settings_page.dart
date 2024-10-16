import 'dart:developer';
import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/Account/accountsettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/aboutsettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/accountstatussettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/blockedusersettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/datasavingsetting.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/devicepermissions.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/helpsettings.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/notificationsetttings.dart';
import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:ARMOYU/app/widgets/Settings/listtile.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  final User currentUser;
  const SettingsPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

TextEditingController _settingsController = TextEditingController();

class _SettingsPage extends State<SettingsPage> {
  List<Map<int, String>> languageList = [];

  List<Map<String, String>> cupertinolist = [
    {'ID': '-1', 'value': 'Seç'}
  ];
  String selectedLanguage = "Türkçe";
  List<WidgetSettings> listSettings = [];
  List<WidgetSettings> filteredlistSettings = [];

  List<WidgetSettings> listSettingssupport = [];
  List<WidgetSettings> filteredlistSettingssupport = [];

  Future<void> logoutfunction() async {
    if (ARMOYU.appUsers.length - 1 == 0) {
      Get.offAllNamed("/login", arguments: {
        "currentUser": widget.currentUser,
        "logOut": widget.currentUser,
      });
    } else {
      // pagecontrollera erişilemediği için yorum satırına alındı

      final appPageController = Get.find<AppPageController>();

      if (mounted) {
        Navigator.pop(context);
      }

      FunctionService f = FunctionService(currentUser: widget.currentUser);
      Map<String, dynamic> response =
          await f.logOut(widget.currentUser.userID!);

      if (response["durum"] == 0) {
        log(response["aciklama"]);
        ARMOYUWidget.toastNotification(response["aciklama"].toString());
        return;
      }

      appPageController.changeAccount(ARMOYU.appUsers.first);
    }
  }

  @override
  void initState() {
    super.initState();

    languageList.add({1: "Türkçe"});
    languageList.add({1: "İngilizce"});
    languageList.add({1: "Almanca"});

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
        tralingText: selectedLanguage,
        onTap: () {
          WidgetUtility.cupertinoselector(
            context: context,
            title: "Dil Seçimi",
            onChanged: (selectedIndex, selectedValue) {
              log(selectedIndex.toString());
              log(selectedValue);

              listSettings[3].tralingText = selectedValue;
              setstatefunction();
            },
            setstatefunction: setstatefunction,
            list: languageList,
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
              builder: (context) =>
                  SettingsNotificationPage(currentUser: widget.currentUser),
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
              builder: (context) =>
                  SettingsBlockeduserPage(currentUser: widget.currentUser),
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
              builder: (context) => SettingsAccountStatusPage(
                currentUser: widget.currentUser,
              ),
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

  setstatefunction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText.costum1('Ayarlar'),
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
                        widget.currentUser.avatar!.mediaURL.minURL,
                      ),
                      radius: 28,
                    ),
                    title: CustomText.costum1(widget.currentUser.displayName!),
                    subtitle: CustomText.costum1(
                        "Hatalı Giriş: ${widget.currentUser.lastfaillogin}"),
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
                        onTap: () async {
                          final result = Get.toNamed("/login", arguments: {
                            "currentUser": widget.currentUser,
                            "accountAdd": true,
                          });

                          if (result != null) {
                            log(result.toString());
                          }
                        },
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
