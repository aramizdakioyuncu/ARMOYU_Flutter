// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api, unused_field, unused_element, must_call_super

import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Screens/search_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../Services/barcode_service.dart';
import '../Services/functions_service.dart';
import '../Services/theme_service.dart';
import '../Widgets/menus.dart';
import 'CameraScreen.dart';
import 'LoginRegister/login_page.dart';
import 'Social/social_page.dart';
import 'notification_page.dart';

class MainPage extends StatefulWidget {
  final changePage;

  MainPage({required this.changePage});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  @override
  bool get wantKeepAlive => true;

  int userID = -1;
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';

  int drawerilkacilis = 0;

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    userID = User.ID;
    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;
  }

  PageController _pageController = PageController(initialPage: 0);
  PageController _pageController2 = PageController(initialPage: 1);
  int _currentPage = 0;
  bool bottombarVisible = true;
  void _changePage(int page) {
    setState(() {
      _currentPage = page;
      // _pageController.jumpToPage(page);
      _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  List<Widget> Widget_myGroups = [];
  List<Widget> Widget_mySchools = [];

  Future<void> loadMyGroups() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.myGroups();
    if (response["durum"] == 0) {
      print(response["aciklama"]);
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
      print(response["aciklama"]);
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
            icon: Icon(Icons.chat_bubble_rounded),
            onPressed: () {
              widget.changePage(1);
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
                  _changePage(3);
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
                  print(response["aciklama"]);
                  return;
                }
                passwordController.text = "";
                // Navigator.of(context).pop();
                Navigator.pushReplacement(context,
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
        physics: NeverScrollableScrollPhysics(), //kaydırma iptali
        controller: _pageController,
        onPageChanged: (int page) {
          // _changePage(page);
        },
        children: [
          PageView(
            controller: _pageController2,
            children: [
              CameraScreen(),
              SocialPage(),
            ],
          ),
          SearchPage(appbar: true),
          NotificationPage(),
          ProfilePage(userID: userID, appbar: false),
        ],
      ),
      bottomNavigationBar: Visibility(
          visible: true,
          child: CustomMenus().mainbottommenu(_currentPage, _changePage)),
    );
  }
}
