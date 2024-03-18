import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Screens/Events/eventlist_page.dart';
import 'package:ARMOYU/Screens/Group/group_create.dart';
import 'package:ARMOYU/Screens/Invite/invite_page.dart';
import 'package:ARMOYU/Screens/News/news_list.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Screens/Restourant/restourant_page.dart';
import 'package:ARMOYU/Screens/School/school_login.dart';
import 'package:ARMOYU/Screens/School/school_page.dart';
import 'package:ARMOYU/Screens/Search/search_page.dart';
import 'package:ARMOYU/Screens/Settings/settings_page.dart';
import 'package:ARMOYU/Screens/Utility/camera_screen_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Services/Utility/barcode.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Services/Utility/theme.dart';
import 'Social/social_page.dart';
import 'Notification/notification_page.dart';

class MainPage extends StatefulWidget {
  final dynamic changePage;

  const MainPage({
    super.key,
    required this.changePage,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  @override
  bool get wantKeepAlive => true;

  bool isBottomNavbarVisible = true;

  bool drawermyschool = false;
  bool drawermygroup = false;
  bool appbarSearch = false;
  final TextEditingController appbarSearchTextController =
      TextEditingController();

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;

  bool firstProcces = false;
  ScrollController homepageScrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    if (!firstProcces) {
      firstProcces = true;
    }

    //Takımları Çek opsiyonel
    ARMOYUFunctions.favteamfetch();
    //Grup Oluştur ekle

    setState(() {
      widgetmyGroups.add(
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: const Icon(Icons.add, size: 30, color: Colors.blue),
          ),
          title: const Text("Grup Oluştur"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GroupCreatePage()));
          },
        ),
      );
      widgetmySchools.add(
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: const Icon(Icons.add, size: 30, color: Colors.blue),
          ),
          title: const Text("Okula Katıl"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SchoolLoginPage()));
          },
        ),
      );
    });
  }

  Future<void> favteamselect(Team team) async {
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.selectfavteam(team.teamID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    ARMOYU.Appuser.favTeam =
        Team(teamID: team.teamID, name: team.name, logo: team.logo);
  }

  final PageController _mainpagecontroller = PageController(initialPage: 0);
  final PageController _pageController2 = PageController(initialPage: 1);

  final PageController _notificationController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool bottombarVisible = true;
  void _changePage(int page) {
    //Anasayfaya basıldığında
    if (page.toString() == "0") {
      setState(() {
        _pageController2.jumpToPage(
          1,
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

    //Bildirimler butonuna basıldığında
    if (page.toString() == "2") {
      //Bildirimler sayfasında bildirimler basarsan en üstte çıkartan kod
      if (_currentPage.toString() == "2") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            _notificationController.animateTo(
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
        appbarSearch = true;
      });
    } else {
      setState(() {
        appbarSearch = false;
      });
    }

    setState(() {
      _currentPage = page;
      _mainpagecontroller.jumpToPage(
        page,
      );
    });
  }

  List<Widget> widgetmyGroups = [];
  List<Widget> widgetmySchools = [];

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
          widgetmyGroups.add(
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
          widgetmySchools.add(
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
                        builder: (context) => const SchoolPage(schoolID: 1)));
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
    return SafeArea(
      child: Scaffold(
        // backgroundColor: ARMOYU.appbarColor,
        appBar: !isBottomNavbarVisible
            ? null
            : AppBar(
                // Arkaplan rengini ayarlayın
                backgroundColor: ARMOYU.appbarColor,

                elevation: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.all(12.0), // İç boşluğu belirleyin
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              50.0), // Kenar yarıçapını ayarlayın
                          child: CachedNetworkImage(
                            imageUrl: ARMOYU.Appuser.avatar!.mediaURL.minURL,
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
                  visible: appbarSearch,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: ARMOYU.textbackColor,
                      borderRadius:
                          BorderRadius.circular(10.0), // Köşe yuvarlama eklemek
                    ),
                    child: TextField(
                      controller: appbarSearchTextController,
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
                    icon: Badge(
                      isLabelVisible:
                          ARMOYU.chatNotificationCount != 0 ? true : false,
                      label: Text(ARMOYU.chatNotificationCount.toString()),
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.chat_bubble_rounded,
                        color: ARMOYU.color,
                      ),
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
                  ARMOYU.Appuser.displayName!,
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(ARMOYU.Appuser.userMail!,
                    style: const TextStyle(color: Colors.white)),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    _changePage(3);
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    foregroundImage: CachedNetworkImageProvider(
                        ARMOYU.Appuser.avatar!.mediaURL.minURL),
                  ),
                ),
                currentAccountPictureSize: const Size.square(70),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        ARMOYU.Appuser.banner!.mediaURL.minURL),
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
                      ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.group, color: ARMOYU.textColor),
                        title: const Text('Gruplarım'),
                        onExpansionChanged: (value) {
                          if (value) {
                            if (!drawermygroup) {
                              loadMyGroups();
                            }
                          }
                        },
                        children: widgetmyGroups.length == 1
                            ? [
                                widgetmyGroups[0],
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CupertinoActivityIndicator(),
                                )
                              ]
                            : widgetmyGroups,
                      ),
                      ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.school, color: ARMOYU.textColor),
                        title: const Text('Okullarım'),
                        onExpansionChanged: (value) {
                          if (value) {
                            if (!drawermyschool) {
                              loadMySchools();
                            }
                          }
                        },
                        children: widgetmySchools.length == 1
                            ? [
                                widgetmySchools[0],
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CupertinoActivityIndicator(),
                                )
                              ]
                            : widgetmySchools,
                      ),
                      ExpansionTile(
                        leading:
                            Icon(Icons.local_drink, color: ARMOYU.textColor),
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
                                  builder: (context) => const RestourantPage(),
                                ),
                              );
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
                        leading: const Icon(Icons.assignment_sharp),
                        title: const Text("Davet Et"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InvitePage(),
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
            ARMOYUFunctions.selectFavTeam(context);
          },
          children: [
            PageView(
              controller: _pageController2,
              onPageChanged: (value) {
                log(value.toString());
                if (value == 0) {
                  setState(() {
                    isBottomNavbarVisible = false;
                  });
                } else {
                  setState(() {
                    isBottomNavbarVisible = true;
                  });
                }
              },
              children: [
                ARMOYU.cameras!.isNotEmpty ? const CameraScreen() : Container(),
                SocialPage(homepageScrollController: homepageScrollController)
              ],
            ),
            SearchPage(
                appbar: true, searchController: appbarSearchTextController),
            NotificationPage(
              scrollController: _notificationController,
            ),
            ProfilePage(userID: ARMOYU.Appuser.userID, appbar: false),
          ],
        ),
        bottomNavigationBar: Visibility(
          visible: isBottomNavbarVisible,
          child: BottomNavigationBar(
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
                icon: Badge(
                  isLabelVisible:
                      (ARMOYU.GroupInviteCount + ARMOYU.friendRequestCount) > 0,
                  label: Text(
                      (ARMOYU.GroupInviteCount + ARMOYU.friendRequestCount)
                          .toString()),
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  child: const Icon(Icons.notifications),
                ),
                label: 'Bildirimler',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  isLabelVisible: false,
                  label: const Text("1"),
                  backgroundColor: ARMOYU.color,
                  textColor: ARMOYU.appbarColor,
                  child: const Icon(Icons.person),
                ),
                label: 'Profil',
              ),
            ],
            currentIndex: _currentPage,
            selectedItemColor: ARMOYU.color,
            unselectedItemColor: Colors.grey,
            onTap: _changePage,
          ),
        ),
      ),
    );
  }
}
