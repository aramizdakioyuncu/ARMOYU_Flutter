// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api

import 'dart:math';

import 'package:ARMOYU/Screens/chat_page.dart';
import 'package:ARMOYU/Screens/login_page.dart';
import 'package:ARMOYU/Screens/main_page.dart';
import 'package:ARMOYU/Screens/notification_page.dart';
import 'package:ARMOYU/Screens/profile_page.dart';
import 'package:ARMOYU/Screens/search_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Services/functions_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Widgets/menus.dart';
import '../Services/barcode_service.dart';
import '../Services/theme_service.dart';

class Pages extends StatefulWidget {
  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int userID = -1;
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';

  int drawerilkacilis = 0;

  @override
  void initState() {
    super.initState();
    userID = User.ID;
    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;
  }

  List<Widget> Widget_myGroups = [];
  List<Widget> Widget_mySchools = [];
  List<Widget> Widget_Posts = [];

  Future<void> loadMyGroups() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.myGroups();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;

    setState(() {
      Widget_myGroups.clear();
      Widget_myGroups.add(
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Icon(
              Icons.add, // İkon türünü burada belirtin
              size: 30, // İkonun boyutunu burada ayarlayabilirsiniz
              color: Colors
                  .blue, // İkonun rengini değiştirmek için burayı kullanabilirsiniz
            ),
          ),
          title: Text("Grup Oluştur"),
          onTap: () {},
        ),
      );
      for (int i = 0; i < dynamicItemCount; i++) {
        Widget_myGroups.add(
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: response["icerik"][i]["grupminnaklogo"],
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
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
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
              child: CachedNetworkImage(
                imageUrl: response["icerik"][i]["okul_minnaklogo"],
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

// /////////////////////////////

  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
      _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Arkaplan rengini ayarlayın
        backgroundColor: Colors.black,

        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
                if (drawerilkacilis == 0) {
                  loadMyGroups();
                  loadMySchools();
                  drawerilkacilis = 1;
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.0), // İç boşluğu belirleyin
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(50.0), // Kenar yarıçapını ayarlayın
                  child: CachedNetworkImage(
                    imageUrl: useravatar,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(
                            appbar: true,
                          )));
            },
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_rounded),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            appbar: true,
                          )));
              // Settings action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  _changePage(1);
                  Navigator.pop(context);
                },
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
              onTap: () async {
                FunctionService f = FunctionService();
                Map<String, dynamic> response = await f.logOut();

                if (response["durum"] == 0) {
                  log(response["aciklama"]);
                  return;
                }
                passwordController.text = "";
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            ListTile(
              // Sağ tarafta bir buton
              trailing: IconButton(
                icon: Icon(Icons.nightlight), // Sağdaki butonun ikonu
                onPressed: () {
                  ThemeProvider().toggleTheme();
                },
              ),
              // Sol tarafta bir buton
              leading: IconButton(
                icon: Icon(Icons.qr_code_2_rounded), // Soldaki butonun ikonu
                onPressed: () async {
                  BarcodeService bc = BarcodeService();
                  String responsew = await bc.scanQR();
                  print(responsew);
                },
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          MainPage(),
          ProfilePage(userID: userID, appbar: false),
          NotificationPage(),
        ],
      ),
      bottomNavigationBar: CustomMenus().bottommenu(_currentPage, _changePage),
    );
  }
}
