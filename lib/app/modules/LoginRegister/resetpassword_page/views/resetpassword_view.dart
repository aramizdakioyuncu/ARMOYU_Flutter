import 'package:armoyu/app/modules/LoginRegister/resetpassword_page/controllers/resetpassword_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:armoyu/app/widgets/buttons.dart';
import 'package:armoyu/app/widgets/textfields.dart';
import 'package:get/get.dart';

class ResetPasswordpageView extends StatelessWidget {
  const ResetPasswordpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetpasswordController());
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Column(
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/armoyu512.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Visibility(
                    visible: controller.step1.value,
                    child: Column(
                      children: [
                        CustomTextfields.costum3(
                          title: ResetPasswordKeys.resetPasswordKeysusername.tr,
                          controller: controller.usernameController,
                          isPassword: false,
                          preicon: const Icon(Icons.person),
                        ),
                        const SizedBox(height: 16),
                        CustomTextfields.costum3(
                          title: ResetPasswordKeys.resetPasswordKeysemail.tr,
                          controller: controller.emailController,
                          isPassword: false,
                          preicon: const Icon(Icons.email),
                        ),
                        const SizedBox(height: 16),
                        ToggleButtons(
                          isSelected: controller.isSelected,
                          onPressed: (int index) {
                            for (int buttonIndex = 0;
                                buttonIndex < controller.isSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                controller.isSelected[buttonIndex] = true;
                              } else {
                                controller.isSelected[buttonIndex] = false;
                              }
                            }

                            {}
                            ();
                          },
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.phone_iphone_rounded,
                                size: 50,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.mail,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButtons.costum1(
                          text: ResetPasswordKeys.resetPasswordKeyscontinue.tr,
                          onPressed: controller.forgotmypassword,
                          loadingStatus: controller.resetpasswordProcess,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ResetPasswordKeys
                                  .resetPasswordKeysifyourememberyourpassword
                                  .tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                ResetPasswordKeys.resetPasswordKeyssignin.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.step2.value,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.alarm,
                                size: 40,
                                color: controller.countdownColor.value,
                              ),
                              const SizedBox(width: 5),
                              CustomText.costum1(
                                controller.passwordtimer.value.toString(),
                                size: 40,
                                weight: FontWeight.bold,
                                color: controller.countdownColor.value,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextfields.number(
                          placeholder:
                              ResetPasswordKeys.resetPasswordKeyscode.tr,
                          controller: controller.codeController.value,
                          length: 6,
                          icon: const Icon(Icons.sms),
                        ),
                        const SizedBox(height: 16),
                        CustomTextfields.costum3(
                          title: ResetPasswordKeys
                              .resetPasswordKeyscreatepassword.tr,
                          controller: controller.passwordController,
                          isPassword: true,
                          preicon: const Icon(Icons.lock_outline),
                        ),
                        const SizedBox(height: 16),
                        CustomTextfields.costum3(
                            title: ResetPasswordKeys
                                .resetPasswordKeysrepeatpassword.tr,
                            controller: controller.repasswordController,
                            isPassword: true,
                            preicon: const Icon(Icons.lock_outline)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: controller.passwordtimer.value != 0,
                              child: CustomButtons.costum1(
                                text:
                                    ResetPasswordKeys.resetPasswordKeyssave.tr,
                                onPressed: controller.forgotmypassworddone,
                                loadingStatus:
                                    controller.resetpasswordauthProcess,
                              ),
                            ),
                            Visibility(
                              visible: controller.passwordtimer.value == 0,
                              child: CustomButtons.costum1(
                                text: ResetPasswordKeys
                                    .resetPasswordKeysrepeatsendcode.tr,
                                onPressed: controller.forgotmypassword,
                                loadingStatus: controller.resetpasswordProcess,
                              ),
                            ),
                          ],
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
