import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountsettingsView extends StatelessWidget {
  const AccountsettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Ayarlar'),
      ),
      body: Column(
        children: [
          Container(color: ARMOYU.bodyColor, height: 1),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.security),
                title: CustomText.costum1("Şifre ve Güvenlik"),
                onTap: () {},
                tileColor: Get.theme.scaffoldBackgroundColor,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts_rounded),
                title: CustomText.costum1("Kişisel Detaylar"),
                onTap: () {},
                tileColor: Get.theme.scaffoldBackgroundColor,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.task_alt_outlined),
                title: CustomText.costum1("Hesabını Doğrula"),
                onTap: () {},
                tileColor: Get.theme.scaffoldBackgroundColor,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: CustomText.costum1("Hesap Gizliliği"),
                onTap: () {},
                tileColor: Get.theme.scaffoldBackgroundColor,
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Herkese Açık'),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
