// ignore_for_file: use_build_context_synchronously

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

  Future<void> _login() async {
    if (loginProcess) {
      return;
    }

    String username = usernameController.text;
    String password = passwordController.text;
    if (username == "" || password == "") {
      if (mounted) {
        ARMOYUWidget.stackbarNotification(
            context, "Kullanıcı adı veya Parola boş olamaz!");
      }
      return;
    }

    setState(() {
      loginProcess = true;
    });

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.login(username, password, false);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      String gelenyanit = response["aciklama"];
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, gelenyanit);
      }
      setState(() {
        loginProcess = false;
      });
      return;
    }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
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
              "Kullanıcı Adı/E-posta",
              controller: usernameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              "Şifreniz",
              controller: passwordController,
              isPassword: true,
              preicon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            CustomButtons.costum1(
              "Giriş Yap",
              onPressed: _login,
              loadingStatus: loginProcess,
            ),
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
                          if (ARMOYU.securityDetail == "0") {
                            FunctionService f = FunctionService();
                            Map<String, dynamic> response =
                                await f.getappdetail();

                            if (response["durum"] == 0) {
                              return;
                            }
                            ARMOYU.securityDetail = response["aciklamadetay"]
                                ["projegizliliksozlesmesi"];
                          }
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TextPage(
                                  texttitle: "Güvenlik Politikası",
                                  textcontent: ARMOYU.securityDetail,
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
                    if (ARMOYU.securityDetail == "0") {
                      FunctionService f = FunctionService();
                      Map<String, dynamic> response = await f.getappdetail();

                      if (response["durum"] == 0) {
                        return;
                      }
                      ARMOYU.securityDetail =
                          response["projegizliliksozlesmesi"];
                    }
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextPage(
                            texttitle: "Güvenlik Politikası",
                            textcontent: ARMOYU.securityDetail,
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
