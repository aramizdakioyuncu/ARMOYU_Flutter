import 'dart:developer';

import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/textfields.dart';

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
        username, name, lastname, email, password, rpassword); //sa

    if (response["durum"] == 0) {
      String text = response["aciklama"];
      if (mounted) {
        ARMOYUWidget.stackbarNotification(context, text);
      }
      log(text);
      setState(() {
        registerProccess = false;
      });
      return;
    }

    if (response["durum"] == 1) {
      usernameController.text = _usernameController.text;
      if (mounted) {
        Navigator.of(context).pop();
      }
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
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/armoyu512.png',
                height: 150,
                width: 150,
              ),
            ),
            CustomTextfields.costum1(
                "Adınız", _nameController, false, const Icon(Icons.person)),
            const SizedBox(height: 16),
            CustomTextfields.costum1("Soyadınız", _lastnameController, false,
                const Icon(Icons.person)),
            const SizedBox(height: 16),
            CustomTextfields.costum1("Kullanıcı Adınız", _usernameController,
                false, const Icon(Icons.person)),
            const SizedBox(height: 16),
            CustomTextfields.costum1(
              "E-posta",
              _emailController,
              false,
              const Icon(Icons.email),
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextfields.costum1("Şifreniz", _passwordController, true,
                const Icon(Icons.lock_outline)),
            const SizedBox(height: 16),
            CustomTextfields.costum1("Şifreniz Tekrar", _rpasswordController,
                true, const Icon(Icons.lock_outline)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextfields.costum1("Davet Kodu",
                      TextEditingController(), false, const Icon(Icons.people)),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
              ],
            ),
            const SizedBox(height: 16),
            CustomButtons.costum1("Kayıt Ol", _register, registerProccess),
            const SizedBox(height: 16),
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
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
