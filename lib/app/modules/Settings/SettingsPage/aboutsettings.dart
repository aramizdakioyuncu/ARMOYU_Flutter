import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsAboutPage extends StatefulWidget {
  const SettingsAboutPage({super.key});

  @override
  State<SettingsAboutPage> createState() => _SettingsAboutPage();
}

class _SettingsAboutPage extends State<SettingsAboutPage> {
  bool lessdata = false;
  bool lessmedia = false;
  bool automedia = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        // backgroundColor: ARMOYU.appbarColor,
        title: const Text('Hakkında'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1("Hesabın Hakkında"),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1("Gizlilik ilkesi"),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1("Kullanım Koşulları"),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1("Açık Kaynak Kütüphaneleri"),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
