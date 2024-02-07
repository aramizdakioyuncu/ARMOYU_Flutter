// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api, unused_field, unused_element, must_call_super, avoid_print, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, empty_catches

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Group/group_create.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Screens/Restourant/restourant_page.dart';
import 'package:ARMOYU/Screens/School/school_login.dart';
import 'package:ARMOYU/Screens/School/school_page.dart';
import 'package:ARMOYU/Screens/Search/search_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Screens/Utility/CameraScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Services/Utility/barcode.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Services/Utility/theme.dart';
import 'package:ARMOYU/Widgets/menus.dart';
import 'LoginRegister/login_page.dart';
import 'Social/social_page.dart';
import 'Notification/notification_page.dart';

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

  bool drawermyschool = false;
  bool drawermygroup = false;
  bool appbar_Search = false;
  final TextEditingController appbar_SearchTextController =
      TextEditingController();

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;
  ScrollController _scrollController = ScrollController();

  ScrollController homepageScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    userID = User.ID;
    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;

    Widget_mySchools.add(
      ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Icon(Icons.add, size: 30, color: Colors.blue),
        ),
        title: Text("Okula Katıl"),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SchoolLoginPage()));
        },
      ),
    );
    Widget_myGroups.add(
      ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Icon(Icons.add, size: 30, color: Colors.blue),
        ),
        title: Text("Grup Oluştur"),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupCreatePage()));
        },
      ),
    );
  }

  PageController _pageController = PageController(initialPage: 0);
  PageController _pageController2 = PageController(initialPage: 1);
  int _currentPage = 0;
  bool bottombarVisible = true;
  void _changePage(int page) {
    if (_currentPage.toString() == "0" && page.toString() == "0") {
      //Anasayfa butonuna anasayfadaykan basarsan en üstte çıkartan kod
      try {
        Future.delayed(Duration(milliseconds: 100), () {
          homepageScrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      } catch (e) {}
      return;
    }

    if (page.toString() == "1") {
      setState(() {
        appbar_Search = true;
      });
    } else {
      appbar_Search = false;
    }

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

    if (mounted) {
      drawermygroup = true;
      setState(() {
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

    if (mounted) {
      drawermyschool = true;
      setState(() {
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SchoolPage(SchoolID: 1)));
              },
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ARMOYU.appbarColor,
      appBar: AppBar(
        // Arkaplan rengini ayarlayın
        backgroundColor: ARMOYU.appbarColor,

        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
                if (!drawermyschool) {
                  loadMySchools();
                }
                if (!drawermygroup) {
                  loadMyGroups();
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.0), // İç boşluğu belirleyin
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(50.0), // Kenar yarıçapını ayarlayın
                  child: CachedNetworkImage(
                    imageUrl: User.avatar,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
        title: Visibility(
          visible: appbar_Search,
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius:
                  BorderRadius.circular(10.0), // Köşe yuvarlama eklemek
            ),
            child: TextField(
              controller: appbar_SearchTextController,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                ),
                hintText: 'Ara',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.chat_bubble_rounded,
              color: ARMOYU.color,
            ),
            onPressed: () {
              widget.changePage(1);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userName,
                style: TextStyle(color: Colors.white),
              ),
              accountEmail:
                  Text(userEmail, style: TextStyle(color: Colors.white)),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  _changePage(3);
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                    foregroundImage: CachedNetworkImageProvider(User.avatar)),
              ),
              currentAccountPictureSize: Size.square(70),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(User.banneravatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Visibility(
                      visible: "-11" == "-1" ? true : false,
                      child: ListTile(
                        textColor: ARMOYU.textColor,
                        iconColor: ARMOYU.textColor,
                        leading: const Icon(Icons.group),
                        title: const Text("Toplantı"),
                        onTap: () {},
                      ),
                    ),
                    ListTile(
                      textColor: ARMOYU.textColor,
                      iconColor: ARMOYU.textColor,
                      leading: const Icon(Icons.article),
                      title: const Text("Haberler"),
                      onTap: () {},
                    ),
                    Visibility(
                      visible: Widget_myGroups.length == 0 ? false : true,
                      child: ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.group, color: ARMOYU.textColor),
                        title: Text('Gruplarım'),
                        children: Widget_myGroups,
                      ),
                    ),
                    Visibility(
                      visible: Widget_mySchools.length == 0 ? false : true,
                      child: ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.school, color: ARMOYU.textColor),
                        title: Text('Okullarım'),
                        children: Widget_mySchools,
                      ),
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.local_drink, color: ARMOYU.textColor),
                      title: Text('Yemek'),
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://aramizdakioyuncu.com/galeri/images/1orijinal11700864001.png",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: const Text("Blackjack F'B Coffee"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestourantPage()));
                          },
                        )
                      ],
                    ),
                    ListTile(
                      textColor: ARMOYU.textColor,
                      iconColor: ARMOYU.textColor,
                      leading: const Icon(Icons.settings),
                      title: const Text("Ayarlar"),
                      onTap: () {},
                    ),
                    ListTile(
                      textColor: ARMOYU.textColor,
                      iconColor: ARMOYU.textColor,
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

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                    ListTile(
                      // Sağ tarafta bir buton
                      trailing: IconButton(
                        icon: Icon(Icons.nightlight,
                            color: ARMOYU.textColor), // Sağdaki butonun ikonu
                        onPressed: () {
                          setState(() {
                            ThemeProvider().toggleTheme();
                          });
                        },
                      ),
                      // Sol tarafta bir buton
                      leading: IconButton(
                        icon: Icon(Icons.qr_code_2_rounded,
                            color: ARMOYU.textColor), // Soldaki butonun ikonu
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
            ),
          ],
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(), //kaydırma iptali
        controller: _pageController,
        onPageChanged: (int page) {
          //  _changePage(page);
        },
        children: [
          PageView(
            controller: _pageController2,
            children: [
              CameraScreen(),
              SocialPage(homepageScrollController: homepageScrollController),
            ],
          ),
          SearchPage(
              appbar: true, searchController: appbar_SearchTextController),
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
