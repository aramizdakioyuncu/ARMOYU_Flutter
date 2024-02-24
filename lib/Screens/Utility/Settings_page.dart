// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
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
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(User.avatar),
                  radius: 25,
                ),
                title: Text(User.displayName),
                subtitle: CustomText().Costum1("Profili Görüntüle"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_rounded),
                title: CustomText().Costum1("Hesap"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.network_wifi_3_bar_rounded),
                title: CustomText().Costum1("Veri Tasarrufu"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: CustomText().Costum1("Diller"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active),
                title: CustomText().Costum1("Bildirimler"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.hourglass_bottom),
                title: CustomText().Costum1("Geçirilen Süre"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: CustomText().Costum1("Engellenenler"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: CustomText().Costum1("Yardım"),
                onTap: () {},
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
              ListTile(
                tileColor: Colors.red,
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: const Icon(Icons.exit_to_app),
                title: CustomText().Costum1(
                  "Çıkış Yap",
                ),
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
                trailing:
                    const Icon(Icons.arrow_forward_ios_outlined, size: 17),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
