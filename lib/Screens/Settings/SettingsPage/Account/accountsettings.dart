import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';

class SettingsAccountPage extends StatefulWidget {
  const SettingsAccountPage({super.key});

  @override
  State<SettingsAccountPage> createState() => _SettingsAccountPage();
}

class _SettingsAccountPage extends State<SettingsAccountPage> {
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
                leading: const Icon(Icons.security),
                title: CustomText().costum1("Şifre ve Güvenlik"),
                onTap: () {},
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts_rounded),
                title: CustomText().costum1("Kişisel Detaylar"),
                onTap: () {},
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_forward_ios_outlined, size: 17),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.task_alt_outlined),
                title: CustomText().costum1("Hesabını Doğrula"),
                onTap: () {},
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
