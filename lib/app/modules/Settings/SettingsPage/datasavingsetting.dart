import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDataSavingPage extends StatefulWidget {
  const SettingsDataSavingPage({super.key});

  @override
  State<SettingsDataSavingPage> createState() => _SettingsDataSavingPage();
}

class _SettingsDataSavingPage extends State<SettingsDataSavingPage> {
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
      appBar: AppBar(
        title: Text(SettingsKeys.dataSaver.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Column(
              children: [
                ListTile(
                  title:
                      CustomText.costum1(DataSaverKeys.useLessCellularData.tr),
                  subtitle: CustomText.costum1(
                    DataSaverKeys.useLessCellularDataExplain.tr,
                  ),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: lessdata,
                        onChanged: (value) {
                          setState(() {
                            lessdata = !lessdata;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1(
                      DataSaverKeys.uploadMediaInTheLowestQuality.tr),
                  subtitle: CustomText.costum1(
                    DataSaverKeys.uploadMediaInTheLowestQualityExplain.tr,
                  ),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: lessmedia,
                        onChanged: (value) {
                          setState(() {
                            lessmedia = !lessmedia;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: CustomText.costum1(
                      DataSaverKeys.disableAutoplayVideos.tr),
                  subtitle: CustomText.costum1(
                    DataSaverKeys.disableAutoplayVideosExplain.tr,
                  ),
                  tileColor: Get.theme.scaffoldBackgroundColor,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: automedia,
                        onChanged: (value) {
                          setState(() {
                            automedia = !automedia;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
