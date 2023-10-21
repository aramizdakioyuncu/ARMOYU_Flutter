// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Sayfası'),
      ),
      body: Column(
        children: [
          Container(
            // Kapak resmi
            color: Colors.blue, // Kapak resmi rengi
            height: 150, // Kapak resmi yüksekliği
          ),
          SizedBox(height: 10),
          CircleAvatar(
            // Profil resmi
            backgroundImage: NetworkImage(
                'https://example.com/your_profile_image.jpg'), // Profil resmi URL'si
            radius: 50, // Profil resmi yarıçapı
          ),
          SizedBox(height: 10),
          Text(
            'Kullanıcı Adı',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Takipçiler: 1000'),
              SizedBox(width: 20),
              Text('Takip Edilen: 500'),
            ],
          ),
          // Profil sayfasının diğer bileşenlerini burada ekleyin
        ],
      ),
    );
  }
}
