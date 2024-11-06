import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/LoginRegister/login_page/controllers/login_controller.dart';
import 'package:ARMOYU/app/modules/LoginRegister/register_page/views/register_view.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/modules/Utility/text_page.dart';

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
            const SizedBox(height: 16.0),
            CustomTextfields.costum3(
              title: "Kullanıcı Adı / E-posta",
              controller: controller.usernameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: "Şifreniz",
              controller: controller.passwordController,
              isPassword: true,
              preicon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomButtons.costum1(
                text: "Giriş Yap",
                onPressed: () async => await controller.login(
                  currentUser: controller.currentUser.value!,
                ),
                loadingStatus: controller.loginProcess,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.toNamed("/ressetpassword");
              },
              child: CustomText.costum1("Şifremi Unuttum"),
            ),
            IconButton(
              icon: const Icon(Icons.nightlight), // Sağdaki butonun ikonu
              onPressed: () {
                Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.costum1("Hesabınız yok mu?"),
                SizedBox(
                  width: ARMOYU.screenWidth / 40,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const RegisterpageView());
                  },
                  child: CustomText.costum1(
                    "Kayıt Ol",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText.costum1("Devam ederek"),
                      InkWell(
                        onTap: () async {
                          if (ARMOYU.securityDetail == "0") {
                            FunctionService f = FunctionService(
                              currentUser: controller.currentUser.value!,
                            );
                            Map<String, dynamic> response =
                                await f.getappdetail();

                            if (response["durum"] == 0) {
                              return;
                            }
                            ARMOYU.securityDetail = response["aciklamadetay"]
                                ["projegizliliksozlesmesi"];
                          }

                          Get.to(
                            () => TextPage(
                              texttitle: "Güvenlik Politikası",
                              textcontent: ARMOYU.securityDetail,
                            ),
                          );
                        },
                        child: CustomText.costum1(" Gizlilik Politikasını",
                            size: 16, weight: FontWeight.bold),
                      ),
                      CustomText.costum1(" ve"),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    if (ARMOYU.securityDetail == "0") {
                      FunctionService f = FunctionService(
                          currentUser: controller.currentUser.value!);
                      Map<String, dynamic> response = await f.getappdetail();

                      if (response["durum"] == 0) {
                        return;
                      }
                      ARMOYU.securityDetail =
                          response["projegizliliksozlesmesi"];
                    }

                    Get.to(
                      () => TextPage(
                        texttitle: "Güvenlik Politikası",
                        textcontent: ARMOYU.securityDetail,
                      ),
                    );
                  },
                  child: CustomText.costum1(
                    "Hizmet Şartlarımızı/Kullanıcı Politikamızı ",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            CustomText.costum1("kabul etmiş olursunuz."),
          ],
        ),
      ),
    );
  }
}
