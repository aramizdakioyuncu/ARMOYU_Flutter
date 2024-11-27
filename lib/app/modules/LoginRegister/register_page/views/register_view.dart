import 'package:ARMOYU/app/modules/LoginRegister/register_page/controllers/register_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class RegisterpageView extends StatelessWidget {
  const RegisterpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterpageController());
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            CustomTextfields.costum3(
              title: RegisterKeys.registerKeysfirstname.tr,
              controller: controller.nameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: RegisterKeys.registerKeyslastname.tr,
              controller: controller.lastnameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: RegisterKeys.registerKeysusername.tr,
              controller: controller.usernameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: RegisterKeys.registerKeysemail.tr,
              controller: controller.emailController,
              isPassword: false,
              preicon: const Icon(Icons.email),
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: RegisterKeys.registerKeyspassword.tr,
              controller: controller.passwordController,
              isPassword: true,
              preicon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: RegisterKeys.registerKeysrepeatpassword.tr,
              controller: controller.rpasswordController,
              isPassword: true,
              preicon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            Obx(
              () => controller.inviteduseravatar.value == null
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomTextfields.costum3(
                            title: RegisterKeys.registerKeysinvitecode.tr,
                            controller: controller.inviteController,
                            isPassword: false,
                            maxLength: 5,
                            preicon: const Icon(Icons.people),
                            suffixiconbutton: IconButton(
                              onPressed: () => controller.davetkodu(),
                              icon: const Icon(
                                Icons.refresh,
                              ),
                            ),
                            onChanged: (value) => controller.davetkodu2(value),
                          ),
                        ),
                      ],
                    )
                  : ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      tileColor: Get.theme.scaffoldBackgroundColor,
                      leading: controller.inviteduseravatar.value != null
                          ? CircleAvatar(
                              foregroundImage: CachedNetworkImageProvider(
                                controller.inviteduseravatar.value.toString(),
                              ),
                            )
                          : Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: const CircleAvatar(
                                radius: 30.0, // Adjust the radius as needed
                                backgroundColor: Colors.white,
                              ),
                            ),
                      title: controller.inviteduserdisplayName.value != null
                          ? Text(controller.inviteduserdisplayName.value
                              .toString())
                          : Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Container(width: 200),
                            ),
                      trailing: IconButton(
                        onPressed: () {
                          controller.inviteduserID.value = null;
                          controller.inviteduseravatar.value = null;
                          controller.inviteduserdisplayName.value = null;
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomButtons.costum1(
                text: RegisterKeys.registerKeyssignup.tr,
                onPressed: () async => await controller.register(),
                loadingStatus: controller.registerProccess,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.costum1(
                  RegisterKeys.registerKeysifyouhaveaccount.tr,
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () => Get.back(),
                  child: CustomText.costum1(RegisterKeys.registerKeyssignin.tr),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
