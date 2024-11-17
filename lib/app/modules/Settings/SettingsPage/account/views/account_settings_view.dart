import 'package:ARMOYU/app/core/widgets.dart';

import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/Settings/SettingsPage/account/controllers/account_settings_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountsettingsView extends StatelessWidget {
  const AccountsettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountSettingsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsKeys.accountSettings.tr),
      ),
      body: Column(
        children: [
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.security),
                title: CustomText.costum1(AccountKeys.passwordandsecurity.tr),
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
                title: CustomText.costum1(AccountKeys.personaldetails.tr),
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
                title: CustomText.costum1(AccountKeys.accountvalidate.tr),
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
                title: CustomText.costum1(AccountKeys.accountprivacy.tr),
                onTap: () {},
                tileColor: Get.theme.scaffoldBackgroundColor,
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: CustomText.costum1(
                  AccountKeys.deleteaccount.tr,
                  color: Colors.red,
                ),
                onTap: () {
                  ARMOYUWidget.showConfirmationDialog(
                    context,
                    accept: () async {
                      Map<String, dynamic> result = await FunctionService(
                        currentUser: controller.user.value!,
                      ).logOut(controller.user.value!.userID!);

                      if (result['durum'] == 1) {
                        ARMOYUWidget.toastNotification(
                          AnswerKeys.yourRequestReceived.tr,
                        );

                        Get.offAllNamed("/login/");
                      } else {
                        ARMOYUWidget.toastNotification(
                          "Sistemsel Bir hata oluştu",
                        );
                      }
                    },
                    question: QuestionKeys.areyousuredetaildescription.tr,
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
