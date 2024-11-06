import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/LoginRegister/register_page/controllers/register_controller.dart';
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
              title: "Adınız",
              controller: controller.nameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: "Soyadınız",
              controller: controller.lastnameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: "Kullanıcı Adınız",
              controller: controller.usernameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              title: "E-posta",
              controller: controller.emailController,
              isPassword: false,
              preicon: const Icon(Icons.email),
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
            CustomTextfields.costum3(
              title: "Şifreniz Tekrar",
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
                            title: "Davet Kodu",
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
                      tileColor: ARMOYU.textbackColor,
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
                      //  const SkeletonAvatar(
                      //     style: SkeletonAvatarStyle(
                      //       borderRadius: BorderRadius.all(
                      //         Radius.circular(30),
                      //       ),
                      //     ),
                      //   ),
                      title: controller.inviteduserdisplayName.value != null
                          ? Text(controller.inviteduserdisplayName.value
                              .toString())
                          : Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: Container(width: 200),
                            ),
                      // const SkeletonLine(
                      //     style: SkeletonLineStyle(width: 200),
                      //   ),
                      trailing: IconButton(
                        onPressed: () {
                          // setState(() {
                          controller.inviteduserID.value = null;
                          controller.inviteduseravatar.value = null;
                          controller.inviteduserdisplayName.value = null;
                          // });
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            CustomButtons.costum1(
              text: "Kayıt Ol",
              onPressed: () async => await controller.register(),
              loadingStatus: controller.registerProccess,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.costum1("Hesabınız varsa  "),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CustomText.costum1("Giriş Yap"),
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
