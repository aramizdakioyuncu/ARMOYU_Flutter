import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpsettingsView extends StatelessWidget {
  const HelpsettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SettingsKeys.help.tr,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title: CustomText.costum1(HelpKeys.reportIssue.tr),
                  subtitle: CustomText.costum1(HelpKeys.reportIssueExplain.tr),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing:
                      const Icon(Icons.arrow_forward_ios_outlined, size: 17),
                ),
                ListTile(
                  title: CustomText.costum1(HelpKeys.supportRequests.tr),
                  subtitle:
                      CustomText.costum1(HelpKeys.supportRequestsExplain.tr),
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
