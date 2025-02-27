import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/modules/LoginRegister/login_page/controllers/login_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/modules/utils/text_page.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/functions/functions_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginpageView extends StatelessWidget {
  const LoginpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginPageController controller = Get.put(LoginPageController());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/armoyu512.png',
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 20.0),
            CustomTextfields.costum3(
              title: LoginKeys.loginKeysUsernameoremail.tr,
              controller: controller.usernameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            CustomTextfields.costum3(
              title: LoginKeys.loginKeysPassword.tr,
              controller: controller.passwordController,
              isPassword: true,
              preicon: const Icon(Icons.lock_outline),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed("/register");
                    },
                    child: CustomText.costum1(
                      LoginKeys.loginKeysHaveyougotaccount.tr,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed("/ressetpassword");
                      },
                      child: CustomText.costum1(
                        LoginKeys.loginKeysForgotmypassword.tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => CustomButtons.costum1(
                text: LoginKeys.loginKeysLogin.tr,
                onPressed: () async => await controller.login(),
                loadingStatus: controller.loginProcess,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      if (ARMOYU.securityDetail == "0") {
                        FunctionService f = FunctionService(API.service);
                        ServiceResult response = await f.getappdetail();

                        if (!response.status) {
                          return;
                        }
                        ARMOYU.securityDetail = response
                            .descriptiondetail["projegizliliksozlesmesi"];
                      }

                      Get.to(
                        () => TextPage(
                          texttitle: "Güvenlik Politikası",
                          textcontent: ARMOYU.securityDetail,
                        ),
                      );
                    },
                    child: CustomText.costum1(
                        LoginKeys.loginKeysPrivacyPolicy.tr,
                        size: 16,
                        weight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (ARMOYU.securityDetail == "0") {
                            FunctionService f = FunctionService(API.service);
                            ServiceResult response = await f.getappdetail();

                            if (!response.status) {
                              return;
                            }
                            ARMOYU.securityDetail = response
                                .descriptiondetail["projegizliliksozlesmesi"];
                          }

                          Get.to(
                            () => TextPage(
                              texttitle: "Güvenlik Politikası",
                              textcontent: ARMOYU.securityDetail,
                            ),
                          );
                        },
                        child: CustomText.costum1(
                          LoginKeys.loginKeysTermsAndConditions.tr,
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomText.costum1(
              LoginKeys.loginKeysacceptanceMessage.tr,
              align: TextAlign.center,
            ),
            IconButton(
              icon: const Icon(Icons.nightlight), // Sağdaki butonun ikonu
              onPressed: () {
                Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
