// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../services/functions_service.dart';
import 'main_page.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Sayfası'),
      ),
      body: Center(
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
                      'assets/images/armoyu128.png'), // Analog görselinizin yolunu ekleyin
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;
                FunctionService f = FunctionService();
                Map<String, dynamic> response =
                    await f.login(username, password); //sa

                if (response["durum"] == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                } else {
                  String gelenyanit = response["aciklama"];
                  final snackBar = SnackBar(
                    content: Text(gelenyanit),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text('Giriş Yap'),
            ),
            TextButton(
              onPressed: () {
                // Şifremi unuttum düğmesine basıldığında yapılacak işlemleri burada tanımlayın
              },
              child: Text('Şifremi Unuttum'),
            ),
            TextButton(
              onPressed: () {
                // Kayıt ol düğmesine basıldığında yapılacak işlemleri burada tanımlayın
              },
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
