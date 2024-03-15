// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Screens/LoginRegister/register_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Screens/LoginRegister/resetpassword_page.dart';
import 'package:ARMOYU/Screens/Utility/text_page.dart';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Services/Utility/theme.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:ARMOYU/Widgets/text.dart';

import 'package:flutter/material.dart';

final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loginProcess = false;

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    if (loginProcess) {
      return;
    }
    setState(() {
      loginProcess = true;
    });

    String username = usernameController.text;
    String password = passwordController.text;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.login(username, password, false);

    if (response["durum"] == 1) {
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Pages(),
          ),
        );
      }

      setState(() {
        loginProcess = false;
      });
    } else {
      log(response["aciklama"]);
      String gelenyanit = response["aciklama"];

      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, gelenyanit);
      }

      setState(() {
        loginProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 110),
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/armoyu512.png'), // Analog görselinizin yolunu ekleyin
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            CustomTextfields.costum1(
              "Kullanıcı Adı/E-posta",
              usernameController,
              false,
              const Icon(Icons.person),
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum1("Şifreniz", passwordController, true,
                const Icon(Icons.lock_outline)),
            const SizedBox(height: 16),
            CustomButtons.costum1("Giriş Yap", _login, loginProcess),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordPage(),
                  ),
                );
              },
              child: CustomText.costum1("Şifremi Unuttum"),
            ),
            IconButton(
              icon: const Icon(Icons.nightlight), // Sağdaki butonun ikonu
              onPressed: () {
                setState(() {
                  ThemeProvider().toggleTheme();
                });
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: CustomText.costum1("Kayıt Ol",
                      size: 16, weight: FontWeight.bold),
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
                          if (ARMOYU.SecurityDetail == "0") {
                            FunctionService f = FunctionService();
                            Map<String, dynamic> response =
                                await f.getappdetail();

                            if (response["durum"] == 0) {
                              return;
                            }
                            ARMOYU.SecurityDetail =
                                response["projegizliliksozlesmesi"];
                          }
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextPage(
                                  texttitle: "Güvenlik Politikası",
                                  textcontent: ARMOYU.SecurityDetail,
                                ),
                              ),
                            );
                          }
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
                    if (ARMOYU.SecurityDetail == "0") {
                      FunctionService f = FunctionService();
                      Map<String, dynamic> response = await f.getappdetail();

                      if (response["durum"] == 0) {
                        return;
                      }
                      ARMOYU.SecurityDetail =
                          response["projegizliliksozlesmesi"];
                    }
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextPage(
                            texttitle: "Güvenlik Politikası",
                            textcontent: ARMOYU.SecurityDetail,
                          ),
                        ),
                      );
                    }
                  },
                  child: CustomText.costum1(
                      "Hizmet Şartlarımızı/Kullanıcı Politikamızı ",
                      size: 16,
                      weight: FontWeight.bold),
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
