// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:developer';

import 'package:armoyu/Screens/login_page.dart';
import 'package:armoyu/services/User.dart';
import 'package:armoyu/services/functions_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

int screenWidth = 20;

class _MainPageState extends State<MainPage> {
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';
  @override
  void initState() {
    super.initState();

    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;

    // initState içinde sayfa yüklendiğinde yapılması gereken işlemleri gerçekleştirin
    loadMyGroups();
    loadMySchools();
  }

  List<Widget> Widget_myGroups = [];
  List<Widget> Widget_mySchools = [];

  Future<void> loadMyGroups() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.myGroups();
    int dynamicItemCount = response["icerik"].length;

    setState(() {
      Widget_myGroups.clear();
      for (int i = 0; i < dynamicItemCount; i++) {
        Widget_myGroups.add(
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                response["icerik"][i]["grupminnaklogo"],
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(response["icerik"][i]["grupadi"]),
            onTap: () {},
          ),
        );
      }
    });
  }

  Future<void> loadMySchools() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.mySchools();
    if (response["icerik"].length == "0") {
      return;
    }
    int dynamicItemCount = response["icerik"].length;
    setState(() {
      Widget_mySchools.clear();
      for (int i = 0; i < dynamicItemCount; i++) {
        Widget_mySchools.add(
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                response["icerik"][i]["okul_minnaklogo"],
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(response["icerik"][i]["okul_adi"]),
            onTap: () {},
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: Center(
                child: CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(useravatar),
                  radius: 40.0,
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(userbanner),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Anasayfa'),
              onTap: () async {},
            ),
            Visibility(
              visible: "-12" == "-1" ? true : false,
              child: ListTile(
                leading: const Icon(Icons.group),
                title: const Text("Toplantı"),
                onTap: () {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text("Haberler"),
              onTap: () {},
            ),
            Visibility(
              visible: Widget_myGroups.length == 0 ? false : true,
              child: ExpansionTile(
                leading: Icon(Icons.group),
                title: Text('Gruplarım'),
                children: Widget_myGroups,
              ),
            ),
            Visibility(
              visible: Widget_mySchools.length == 0 ? false : true,
              child: ExpansionTile(
                leading: Icon(Icons.school),
                title: Text('Okullarım'),
                children: Widget_mySchools,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Ayarlar"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Çıkış Yap'),
              tileColor: Colors
                  .red, // TileColor özelliği ile arka plan rengini ayarlayın
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Anasayfa'),
      ),
    );
  }
}
