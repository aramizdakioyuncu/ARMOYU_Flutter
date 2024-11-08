import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/datasaving/controllers/datasaving_settings_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatasavingSettingsView extends StatelessWidget {
  const DatasavingSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DatasavingSettingsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsKeys.dataSaver.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(color: ARMOYU.bodyColor, height: 1),
            Obx(
              () => Column(
                children: [
                  ListTile(
                    title: CustomText.costum1(
                        DataSaverKeys.useLessCellularData.tr),
                    subtitle: CustomText.costum1(
                      DataSaverKeys.useLessCellularDataExplain.tr,
                    ),
                    tileColor: Get.theme.scaffoldBackgroundColor,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: controller.lessdata.value,
                          onChanged: (value) {
                            controller.lessdata.value =
                                !controller.lessdata.value;
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
                          value: controller.lessmedia.value,
                          onChanged: (value) {
                            controller.lessmedia.value =
                                !controller.lessmedia.value;
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
                          value: controller.automedia.value,
                          onChanged: (value) {
                            controller.automedia.value =
                                !controller.automedia.value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
