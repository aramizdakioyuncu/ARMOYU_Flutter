// ignore_for_file: avoid_print, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Widgets/notifications.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rpasswordController = TextEditingController();

  bool registerProccess = false;

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

    if (name == "" ||
        username == "" ||
        lastname == "" ||
        email == "" ||
        password == "" ||
        rpassword == "") {
      String text = "Boş alan bırakmayınız!";
      CustomNotifications.stackbarNotification(context, text);
      log(text);

      setState(() {
        registerProccess = false;
      });
      return;
    }
    if (password != rpassword) {
      String text = "Parolalarınız eşleşmedi!";
      CustomNotifications.stackbarNotification(context, text);
      log(text);

      setState(() {
        registerProccess = false;
      });
      return;
    }

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.register(
        username, name, lastname, email, password, rpassword); //sa

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      CustomNotifications.stackbarNotification(context, text);
      log(text);
      setState(() {
        registerProccess = false;
      });
      return;
    }

    if (response["durum"] == 1) {
      usernameController.text = _usernameController.text;

      Navigator.of(context).pop();
      setState(() {
        registerProccess = false;
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
          children: [
            SizedBox(height: 60),
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
            CustomTextfields()
                .Costum1("Adınız", _nameController, false, Icon(Icons.person)),
            SizedBox(height: 16),
            CustomTextfields().Costum1(
                "Soyadınız", _lastnameController, false, Icon(Icons.person)),
            SizedBox(height: 16),
            CustomTextfields().Costum1("Kullanıcı Adınız", _usernameController,
                false, Icon(Icons.person)),
            SizedBox(height: 16),
            CustomTextfields().Costum1(
              "E-posta",
              _emailController,
              false,
              Icon(Icons.email),
              TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            CustomTextfields().Costum1("Şifreniz", _passwordController, true,
                Icon(Icons.lock_outline)),
            SizedBox(height: 16),
            CustomTextfields().Costum1("Şifreniz Tekrar", _rpasswordController,
                true, Icon(Icons.lock_outline)),
            SizedBox(height: 16),
            CustomButtons().Costum1("Kayıt Ol", _register, registerProccess),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hesabınız varsa  ",
                  style: TextStyle(color: Colors.white),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Giriş Yap",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
