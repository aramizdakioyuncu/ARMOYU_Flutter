// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:developer';

import 'package:ARMOYU/Services/User.dart';
import 'package:flutter/material.dart';

import '../Services/functions_service.dart';
import 'FullScreenImagePage.dart';

class ProfilePage extends StatefulWidget {
  final int userID; // Zorunlu olarak alınacak veri

  ProfilePage({required this.userID});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;
  String userName = "...";
  String displayName = "...";
  String banneravatar =
      "https://upload.wikimedia.org/wikipedia/commons/b/b9/Youtube_loading_symbol_1_(wobbly).gif";
  String avatar =
      "https://upload.wikimedia.org/wikipedia/commons/b/b9/Youtube_loading_symbol_1_(wobbly).gif";
  @override
  void initState() {
    super.initState();

    TEST();
  }

  Future<void> TEST() async {
    if (widget.userID == User.ID) {
      userName = User.userName;
      displayName = User.displayName;
      banneravatar = User.banneravatar;
      avatar = User.avatar;
      return;
    }

    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.lookProfile(widget.userID);
    if (response["durum"] == 0) {
      log("Oyuncu bulunamadı");
      return;
    }

    userName = response["kullaniciadi"];
    displayName = response["adim"];
    banneravatar = response["parkaresimufak"];
    avatar = response["presimminnak"];

    log(userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.black, // Container'ın arka plan rengi
            height: 160, // Container'ın yüksekliği
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullScreenImagePage(
                        images: [banneravatar],
                        initialIndex: 0,
                      ),
                    ));
                  },
                  child: Image.network(
                    banneravatar,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              images: [avatar],
                              initialIndex: 0,
                            ),
                          ));
                        },
                        child: Hero(
                          tag:
                              'imageTag', // Aynı tag değerini detay sayfasındaki Hero widget'ı ile eşleştirmelisiniz.
                          child: ClipOval(
                            child: Image.network(
                              avatar, // Yuvarlak görüntülenmesini istediğiniz resmin URL'si
                              width: 100, // Yuvarlak resmin genişliği
                              height: 100, // Yuvarlak resmin yüksekliği
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(55, 0, 0, 0), // Arka plan rengi
                        padding: EdgeInsets.all(8),
                        // İstediğiniz içerik boşluğunu ekleyin
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white, // Metin rengi
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 10),

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
