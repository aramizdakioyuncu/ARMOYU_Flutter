// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/Settings/SettingsPage/Account/accountsettings.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    foregroundImage: CachedNetworkImageProvider(User.avatar),
                    radius: 28,
                  ),
                  title: Text(User.displayName),
                  subtitle:
                      CustomText().Costum1("Son Hatalı Giriş: 20.02.2002"),
                  // onTap: () {},
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
              ),
              const SizedBox(height: 40),
              ListTile(
                leading: const Icon(Icons.account_circle_rounded),
                title: CustomText().Costum1("Hesap"),
                tileColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsAccountPage(),
                    ),
                  );
                },
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Icon(
                        Icons.network_wifi_3_bar_rounded,
                      ),
                      title: CustomText().Costum1("Veri Tasarrufu"),
                      tileColor: Colors.white,
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
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: CustomText().Costum1("Diller"),
                    onTap: () {},
                    tileColor: Colors.white,
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Türkçe'),
                        ),
                        Icon(Icons.arrow_forward_ios_outlined, size: 17),
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: CustomText().Costum1("Bildirimler"),
                onTap: () {},
                tileColor: Colors.white,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Hepsi Açık'),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: CustomText().Costum1("Engellenenler"),
                onTap: () {},
                tileColor: Colors.white,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('10'),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: CustomText().Costum1("Yardım"),
                onTap: () {},
                tileColor: Colors.white,
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: CustomText().Costum1("Hakkında"),
                onTap: () {},
                tileColor: Colors.white,
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                textColor: Colors.red,
                iconColor: Colors.red,
                leading: const Icon(Icons.exit_to_app),
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
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
