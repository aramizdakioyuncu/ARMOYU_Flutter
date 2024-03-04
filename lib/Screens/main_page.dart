// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Events/eventlist_page.dart';
import 'package:ARMOYU/Screens/Group/group_create.dart';
import 'package:ARMOYU/Screens/News/news_list.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Screens/Restourant/restourant_page.dart';
import 'package:ARMOYU/Screens/School/school_login.dart';
import 'package:ARMOYU/Screens/School/school_page.dart';
import 'package:ARMOYU/Screens/Search/search_page.dart';
import 'package:ARMOYU/Screens/Settings/settings_page.dart';
import 'package:ARMOYU/Services/appuser.dart';
import 'package:ARMOYU/Screens/Utility/cameraScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Services/Utility/barcode.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Services/Utility/theme.dart';
import 'Social/social_page.dart';
import 'Notification/notification_page.dart';

class MainPage extends StatefulWidget {
  final changePage;

  const MainPage({super.key, required this.changePage});

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

  ScrollController homepageScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    userID = AppUser.ID;
    userName = AppUser.displayName;
    userEmail = AppUser.mail;
    useravatar = AppUser.avatar;
    userbanner = AppUser.banneravatar;

    Widget_mySchools.add(
      ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: const Icon(Icons.add, size: 30, color: Colors.blue),
        ),
        title: const Text("Okula Katıl"),
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
          child: const Icon(Icons.add, size: 30, color: Colors.blue),
        ),
        title: const Text("Grup Oluştur"),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupCreatePage()));
        },
      ),
    );
  }

  final PageController _mainpagecontroller = PageController(initialPage: 0);
  final PageController _pageController2 = PageController(initialPage: 1);
  int _currentPage = 0;
  bool bottombarVisible = true;
  void _changePage(int page) {
    //Anasayfaya basıldığında
    if (page.toString() == "0") {
      setState(() {
        _pageController2.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });

      //Anasayfa butonuna anasayfadaykan basarsan en üstte çıkartan kod
      if (_currentPage.toString() == "0") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            homepageScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        } catch (e) {
          log(e.toString());
        }
        return;
      }
    }

    if (page.toString() == "1") {
      setState(() {
        appbar_Search = true;
      });
    } else {
      setState(() {
        appbar_Search = false;
      });
    }

    setState(() {
      _currentPage = page;
      _mainpagecontroller.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
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
      log(response["aciklama"].toString());
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
      log(response["aciklama"].toString());
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
    super.build(context);
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
                padding: const EdgeInsets.all(12.0), // İç boşluğu belirleyin
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(50.0), // Kenar yarıçapını ayarlayın
                  child: CachedNetworkImage(
                    imageUrl: AppUser.avatar,
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
            height: 40,
            decoration: BoxDecoration(
              color: ARMOYU.textbackColor,
              borderRadius:
                  BorderRadius.circular(10.0), // Köşe yuvarlama eklemek
            ),
            child: TextField(
              controller: appbar_SearchTextController,
              style: TextStyle(
                color: ARMOYU.textColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                ),
                hintText: 'Ara',
                border: InputBorder.none,
                hintStyle: TextStyle(color: ARMOYU.textColor),
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
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail:
                  Text(userEmail, style: const TextStyle(color: Colors.white)),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  _changePage(3);
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                    foregroundImage:
                        CachedNetworkImageProvider(AppUser.avatar)),
              ),
              currentAccountPictureSize: const Size.square(70),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(AppUser.banneravatar),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewslistPage()));
                      },
                    ),
                    Visibility(
                      visible: Widget_myGroups.isEmpty ? false : true,
                      child: ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.group, color: ARMOYU.textColor),
                        title: const Text('Gruplarım'),
                        children: Widget_myGroups,
                      ),
                    ),
                    Visibility(
                      visible: Widget_mySchools.isEmpty ? false : true,
                      child: ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.school, color: ARMOYU.textColor),
                        title: const Text('Okullarım'),
                        children: Widget_mySchools,
                      ),
                    ),
                    ExpansionTile(
                      leading: Icon(Icons.local_drink, color: ARMOYU.textColor),
                      title: const Text('Yemek'),
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
                      leading: const Icon(Icons.event),
                      title: const Text("Etkinlikler"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventlistPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      textColor: ARMOYU.textColor,
                      iconColor: ARMOYU.textColor,
                      leading: const Icon(Icons.settings),
                      title: const Text("Ayarlar"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      // Sağ tarafta bir buton
                      trailing: IconButton(
                        icon: Icon(Icons.nightlight,
                            color: ARMOYU.textColor), // Sağdaki butonun ikonu
                        onPressed: () {
                          ThemeProvider().toggleTheme();

                          setState(() {});
                        },
                      ),
                      // Sol tarafta bir buton
                      leading: IconButton(
                        icon: Icon(Icons.qr_code_2_rounded,
                            color: ARMOYU.textColor), // Soldaki butonun ikonu
                        onPressed: () async {
                          BarcodeService bc = BarcodeService();
                          String responsew = await bc.scanQR();
                          log(responsew);
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
        physics: const NeverScrollableScrollPhysics(), //kaydırma iptali
        controller: _mainpagecontroller,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Arama',
          ),
          BottomNavigationBarItem(
            icon: 1 == 1
                ? const Icon(Icons.notifications)
                : Stack(
                    children: <Widget>[
                      const Icon(Icons.notifications), // Bildirim ikonu
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints:
                              const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: const Text(
                            '15',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
            label: 'Bildirimler',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentPage,
        selectedItemColor: ARMOYU.color,
        unselectedItemColor: Colors.grey,
        onTap: _changePage,
      ),
    );
  }
}
