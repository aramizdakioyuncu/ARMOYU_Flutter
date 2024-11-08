import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/about/controllers/about_settings_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutSettingsView extends StatelessWidget {
  const AboutSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AboutSettingsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsKeys.about.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1(AboutKeys.aboutYourAccount.tr),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1(AboutKeys.privacyPolicy.tr),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1(AboutKeys.privacyPolicy.tr),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1(AboutKeys.openSourceLibraries.tr),
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
