// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, override_on_non_overriding_member, library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_print

import 'package:ARMOYU/Core/screen.dart';
import 'package:ARMOYU/Screens/LoginRegister/register_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Screens/LoginRegister/resetpassword_page.dart';
import 'package:ARMOYU/Screens/text_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';

import '../../Services/App.dart';
import '../../Services/functions_service.dart';
import '../../Services/theme_service.dart';
import '../../Widgets/buttons.dart';
import '../../Widgets/textfields.dart';

final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
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
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Pages()));
      setState(() {
        loginProcess = false;
      });
    } else {
      print(response["aciklama"]);

      String gelenyanit = response["aciklama"];
      final snackBar = SnackBar(
        content: Text(gelenyanit),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            SizedBox(height: 110),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/armoyu512.png'), // Analog görselinizin yolunu ekleyin
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            CustomTextfields().Costum1("Kullanıcı Adınız", usernameController,
                false, Icon(Icons.person)),
            SizedBox(height: 16),
            CustomTextfields().Costum1(
                "Şifreniz", passwordController, true, Icon(Icons.lock_outline)),
            SizedBox(height: 16),
            CustomButtons().Costum1("Giriş Yap", _login, loginProcess),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordPage(),
                  ),
                );
              },
              child: CustomText().Costum1("Şifremi Unuttum"),
            ),
            IconButton(
              icon: Icon(Icons.nightlight), // Sağdaki butonun ikonu
              onPressed: () {
                setState(() {
                  ThemeProvider().toggleTheme();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText().Costum1("Hesabınız yok mu?"),
                SizedBox(
                  width: Screen.screenWidth / 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                  child: CustomText()
                      .Costum1("Kayıt Ol", size: 16, weight: FontWeight.bold),
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
                      CustomText().Costum1("Devam ederek"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TextPage(
                                texttitle: "Güvenlik Politikası",
                                textcontent: App.SecurityDetail,
                              ),
                            ),
                          );
                        },
                        child: CustomText().Costum1(" Gizlilik Politikasını",
                            size: 16, weight: FontWeight.bold),
                      ),
                      CustomText().Costum1(" ve"),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TextPage(
                          texttitle: "Güvenlik Politikası",
                          textcontent: App.SecurityDetail,
                        ),
                      ),
                    );
                  },
                  child: CustomText().Costum1(
                      "Hizmet Şartlarımızı/Kullanıcı Politikamızı ",
                      size: 16,
                      weight: FontWeight.bold),
                ),
              ],
            ),
            CustomText().Costum1("kabul etmiş olursunuz."),
          ],
        ),
      ),
    );
  }
}
