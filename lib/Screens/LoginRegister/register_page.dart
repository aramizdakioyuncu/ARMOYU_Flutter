import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/loginregister.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';
import 'package:skeletons/skeletons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rpasswordController = TextEditingController();
  final TextEditingController _inviteController = TextEditingController();

  bool registerProccess = false;
  bool inviteCodeProcces = false;

  String? inviteduserID;
  String? inviteduserdisplayName;
  String? inviteduseravatar;
  Future<void> invitecodeTester(String code) async {
    if (inviteCodeProcces) {
      return;
    }
    setState(() {
      inviteCodeProcces = true;
    });

    FunctionsLoginRegister f = FunctionsLoginRegister();
    Map<String, dynamic> response = await f.inviteCodeTest(code);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, response["aciklama"]);
      }
      setState(() {
        inviteCodeProcces = false;
      });
      return;
    }
    log(inviteduserID = response["aciklamadetay"]["oyuncu_ID"].toString());
    log(inviteduseravatar =
        response["aciklamadetay"]["oyuncu_avatar"].toString());
    log(inviteduserdisplayName =
        response["aciklamadetay"]["oyuncu_displayName"].toString());
    setState(() {
      inviteCodeProcces = false;
    });
  }

  Future<void> _register() async {
    if (registerProccess) {
      return;
    }
    setState(() {
      registerProccess = true;
    });
    // Kayıt işlemini burada gerçekleştirin
    final username = _usernameController.text;
    final name = _nameController.text;
    final lastname = _lastnameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final rpassword = _rpasswordController.text;
    final inviteCode = _inviteController.text;

    if (name == "" ||
        username == "" ||
        lastname == "" ||
        email == "" ||
        password == "" ||
        rpassword == "") {
      String text = "Boş alan bırakmayınız!";
      ARMOYUWidget.stackbarNotification(context, text);
      log(text);

      setState(() {
        registerProccess = false;
      });
      return;
    }
    if (password != rpassword) {
      String text = "Parolalarınız eşleşmedi!";
      ARMOYUWidget.stackbarNotification(context, text);
      log(text);

      setState(() {
        registerProccess = false;
      });
      return;
    }

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.register(
        username, name, lastname, email, password, rpassword, inviteCode);

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, text);
      }
      setState(() {
        registerProccess = false;
      });
      return;
    }

    if (response["durum"] == 1) {
      usernameController.text = _usernameController.text;

      Map<String, dynamic> loginresponse =
          await f.login(username, password, true);

      if (loginresponse["aciklama"] == "Başarılı.") {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Pages(),
            ),
          );
        }
        return;
      }

      setState(() {
        registerProccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
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
              "Adınız",
              controller: _nameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              "Soyadınız",
              controller: _lastnameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              "Kullanıcı Adınız",
              controller: _usernameController,
              isPassword: false,
              preicon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              "E-posta",
              controller: _emailController,
              isPassword: false,
              preicon: const Icon(Icons.email),
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              "Şifreniz",
              controller: _passwordController,
              isPassword: true,
              preicon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum3(
              "Şifreniz Tekrar",
              controller: _rpasswordController,
              isPassword: true,
              preicon: const Icon(Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            inviteduseravatar == null
                ? Row(
                    children: [
                      Expanded(
                        child: CustomTextfields.costum3(
                          "Davet Kodu",
                          controller: _inviteController,
                          isPassword: false,
                          maxLength: 5,
                          preicon: const Icon(Icons.people),
                          suffixiconbutton: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_inviteController.text.length == 5) {
                                    log("5 karakter yazıldı: ${_inviteController.text}");
                                    invitecodeTester(_inviteController.text);
                                  }
                                });
                              },
                              icon: const Icon(Icons.refresh)),
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                if (value.length == 5) {
                                  log("5 karakter yazıldı: $value");

                                  invitecodeTester(value);
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    tileColor: ARMOYU.textbackColor,
                    leading: inviteduseravatar != null
                        ? CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                              inviteduseravatar.toString(),
                            ),
                          )
                        : const SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                    title: inviteduserdisplayName != null
                        ? Text(inviteduserdisplayName.toString())
                        : const SkeletonLine(
                            style: SkeletonLineStyle(width: 200),
                          ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          inviteduserID = null;
                          inviteduseravatar = null;
                          inviteduserdisplayName = null;
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                  ),
            const SizedBox(height: 16),
            CustomButtons.costum1(
              "Kayıt Ol",
              onPressed: _register,
              loadingStatus: registerProccess,
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
