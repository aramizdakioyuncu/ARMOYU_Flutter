// ignore_for_file: avoid_print, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors

import 'package:ARMOYU/Screens/login_page.dart';
import 'package:flutter/material.dart';

import '../Widgets/buttons.dart';
import '../Widgets/textfields.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    // Kayıt işlemini burada gerçekleştirin
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    // Örneğin, bu bilgileri bir API'ye gönderebilirsiniz.
    print('Name: $name');
    print('Email: $email');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                "Soyadınız", _nameController, false, Icon(Icons.person)),
            SizedBox(height: 16),
            CustomTextfields().Costum1(
                "Kullanıcı Adınız", _nameController, false, Icon(Icons.person)),
            SizedBox(height: 16),
            CustomTextfields()
                .Costum1("E-posta", _emailController, false, Icon(Icons.email)),
            SizedBox(height: 16),
            CustomTextfields().Costum1("Şifreniz", _passwordController, true,
                Icon(Icons.lock_outline)),
            SizedBox(height: 16),
            CustomTextfields().Costum1("Şifreniz Tekrar", _passwordController,
                true, Icon(Icons.lock_outline)),
            SizedBox(height: 16),
            CustomButtons().Costum1("Kayıt Ol", _register),
            SizedBox(height: 16),
            Container(
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
