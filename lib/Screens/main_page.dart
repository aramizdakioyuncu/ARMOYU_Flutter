// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/API_Functions/station.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/station.dart';
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
import 'package:ARMOYU/Screens/Survey/surveylist_page.dart';
import 'package:ARMOYU/Screens/Utility/camera_screen_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Services/Utility/barcode.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Services/Utility/theme.dart';
import 'package:skeletons/skeletons.dart';
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
  bool drawermyfood = false;
  bool appbarSearch = false;
  final TextEditingController appbarSearchTextController =
      TextEditingController();

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;

  bool firstProcces = false;
  final PageController _mainpagecontroller = PageController(initialPage: 0);
  final PageController _pageController2 = PageController(initialPage: 1);

  final ScrollController _homepageScrollController = ScrollController();
  final ScrollController _searchScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController _notificationScrollController =
      ScrollController(initialScrollOffset: 0);
  final ScrollController _profileScrollController =
      ScrollController(initialScrollOffset: 0);
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
                builder: (context) => const SchoolLoginPage(),
              ),
            );
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

    ARMOYU.appUser.favTeam =
        Team(teamID: team.teamID, name: team.name, logo: team.logo);
  }

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
            _homepageScrollController.animateTo(
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

    //Arama butonuna basıldığında
    if (page.toString() == "1") {
      //Arama sayfasında aramaya basarsan en üstte çıkartan kod
      if (_currentPage.toString() == "1") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            _searchScrollController.animateTo(
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
            _notificationScrollController.animateTo(
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

    //Profil butonuna basıldığında
    if (page.toString() == "3") {
      //Profil sayfasında profile basarsan en üstte çıkartan kod
      if (_currentPage.toString() == "3") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            _profileScrollController.animateTo(
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
  List<Station> widgetFoodStation = [];

  bool loadGroupProcess = false;
  Future<void> loadMyGroups() async {
    if (loadGroupProcess) {
      return;
    }
    loadGroupProcess = true;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.myGroups();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      loadGroupProcess = false;

      return;
    }
    if (response["icerik"].length == 0) {
      loadGroupProcess = false;
      return;
    }

    if (mounted) {
      drawermygroup = true;
      setState(() {
        for (dynamic element in response["icerik"]) {
          widgetmyGroups.add(
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: element["grupminnaklogo"],
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(element["grupadi"]),
              onTap: () {},
            ),
          );
        }
      });
    }
  }

  bool loadfoodStationProcess = false;

  Future<void> loadFoodStation() async {
    if (loadfoodStationProcess) {
      return;
    }
    loadfoodStationProcess = true;

    FunctionsStation f = FunctionsStation();
    Map<String, dynamic> response = await f.fetchfoodstation();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      loadfoodStationProcess = false;
      return;
    }
    widgetFoodStation.clear();
    for (dynamic element in response["icerik"]) {
      if (mounted) {
        setState(() {
          widgetFoodStation.add(
            Station(
              stationID: element["station_ID"],
              name: element["station_name"],
              logo: Media(
                mediaID: element["station_ID"],
                mediaURL: MediaURL(
                  bigURL: element["station_logo"],
                  normalURL: element["station_logo"],
                  minURL: element["station_logo"],
                ),
              ),
              banner: Media(
                mediaID: element["station_ID"],
                mediaURL: MediaURL(
                  bigURL: element["station_banner"],
                  normalURL: element["station_banner"],
                  minURL: element["station_banner"],
                ),
              ),
            ),
          );
        });
      }
    }
    drawermyfood = true;
    loadfoodStationProcess = false;
  }

  bool loadmySchoolProcess = false;
  Future<void> loadMySchools() async {
    if (loadmySchoolProcess) {
      return;
    }
    loadmySchoolProcess = true;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.mySchools();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      loadmySchoolProcess = false;
      return;
    }

    if (response["icerik"].length == 0) {
      loadmySchoolProcess = false;

      return;
    }

    if (mounted) {
      drawermyschool = true;
      for (int i = 0; i < response["icerik"].length; i++) {
        setState(() {
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
        });
      }
      loadmySchoolProcess = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _currentPage = 0;
          _mainpagecontroller.jumpToPage(
            0,
          );
          _pageController2.jumpToPage(1);
        });
        return false;
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          // backgroundColor: ARMOYU.backgroundcolor,
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
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: ARMOYU.appUser.avatar == null
                                ? const SkeletonAvatar()
                                : CachedNetworkImage(
                                    imageUrl:
                                        ARMOYU.appUser.avatar!.mediaURL.minURL,
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
                        color: ARMOYU.bodyColor,
                        borderRadius: BorderRadius.circular(
                            10.0), // Köşe yuvarlama eklemek
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
            backgroundColor: ARMOYU.appbarColor,
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: ARMOYU.appUser.displayName == null
                      ? const SkeletonLine(
                          style: SkeletonLineStyle(width: 20),
                        )
                      : Text(
                          ARMOYU.appUser.displayName!,
                          style: const TextStyle(color: Colors.white),
                        ),
                  accountEmail: ARMOYU.appUser.userMail == null
                      ? const SkeletonLine(
                          style: SkeletonLineStyle(width: 20),
                        )
                      : Text(ARMOYU.appUser.userMail!,
                          style: const TextStyle(color: Colors.white)),
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      _changePage(3);
                      Navigator.of(context).pop();
                    },
                    child: ARMOYU.appUser.avatar == null
                        ? const SkeletonAvatar()
                        : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundImage: CachedNetworkImageProvider(
                                ARMOYU.appUser.avatar!.mediaURL.minURL),
                          ),
                  ),
                  currentAccountPictureSize: const Size.square(70),
                  decoration: ARMOYU.appUser.banner == null
                      ? null
                      : BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                ARMOYU.appUser.banner!.mediaURL.minURL),
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
                                    builder: (context) =>
                                        const NewslistPage()));
                          },
                        ),
                        ExpansionTile(
                          textColor: ARMOYU.textColor,
                          leading: Icon(Icons.group, color: ARMOYU.textColor),
                          title: const Text('Gruplarım'),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!drawermygroup) {
                                await loadMyGroups();
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
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!drawermyschool) {
                                await loadMySchools();
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
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!drawermyfood) {
                                await loadFoodStation();
                              }
                            }
                          },
                          children: widgetFoodStation.isEmpty
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CupertinoActivityIndicator(),
                                  )
                                ]
                              : List.generate(widgetFoodStation.length,
                                  (index) {
                                  return ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        imageUrl: widgetFoodStation[index]
                                            .logo
                                            .mediaURL
                                            .minURL,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(widgetFoodStation[index].name),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RestourantPage(
                                            cafe: widgetFoodStation[index],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
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
                          leading: const Icon(Icons.analytics_rounded),
                          title: const Text("Anketler"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SurveyListPage(),
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
                            icon:
                                Icon(Icons.nightlight, color: ARMOYU.textColor),
                            onPressed: () {
                              setState(() {
                                ThemeProvider().toggleTheme();
                              });
                            },
                          ),
                          // Sol tarafta bir buton
                          leading: IconButton(
                            icon: Icon(Icons.qr_code_2_rounded,
                                color: ARMOYU.textColor),
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
                  ARMOYU.cameras!.isNotEmpty
                      ? const CameraScreen()
                      : Container(),
                  SocialPage(
                    homepageScrollController: _homepageScrollController,
                  )
                ],
              ),
              SearchPage(
                appbar: true,
                searchController: appbarSearchTextController,
                scrollController: _searchScrollController,
              ),
              NotificationPage(
                scrollController: _notificationScrollController,
              ),
              ProfilePage(
                userID: ARMOYU.appUser.userID,
                appbar: false,
                scrollController: _profileScrollController,
              ),
            ],
          ),
          bottomNavigationBar: Visibility(
            visible: isBottomNavbarVisible,
            child: BottomNavigationBar(
              backgroundColor: ARMOYU.appbarColor,
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
                        (ARMOYU.groupInviteCount + ARMOYU.friendRequestCount) >
                            0,
                    label: Text(
                        (ARMOYU.groupInviteCount + ARMOYU.friendRequestCount)
                            .toString()),
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
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
      ),
    );
  }
}
