import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/API_Functions/teams.dart';
import 'package:ARMOYU/Models/team.dart';
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
import 'package:ARMOYU/Screens/Utility/camera_screen_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  final List<Team> favoriteteams = [];

  bool drawermyschool = false;
  bool drawermygroup = false;
  bool appbarSearch = false;
  final TextEditingController appbarSearchTextController =
      TextEditingController();

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;

  ScrollController homepageScrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    //Takımları Çek opsiyonel
    favteamfetch();
  }

  Future<void> favteamfetch() async {
    if (AppUser.favTeam != null) {
      return;
    }
    FunctionsTeams f = FunctionsTeams();
    Map<String, dynamic> response = await f.fetch();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    for (int i = 0; response["icerik"].length > i; i++) {
      favoriteteams.add(
        Team(
          teamID: response["icerik"][i]["takim_ID"],
          name: response["icerik"][i]["takim_adi"],
          logo: response["icerik"][i]["takim_logo"],
        ),
      );
    }
  }

  Future<void> favteamselect(Team team) async {
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.selectfavteam(team.teamID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    AppUser.favTeam =
        Team(teamID: team.teamID, name: team.name, logo: team.logo);
  }

  void favteamSelection() {
    if (AppUser.favTeam != null) {
      return;
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            width: ARMOYU.screenWidth * 0.95,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Favori Takımını Seç',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          favoriteteams.length,
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(favoriteteams[index]);
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: favoriteteams[index].logo,
                                    height: 60,
                                    width: 60,
                                  ),
                                  Text(favoriteteams[index].name),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((selectedTeam) {
      // Kullanıcının seçtiği takımı işle
      if (selectedTeam != null) {
        log('Seçilen Takım: ${selectedTeam.name}');
        favteamselect(selectedTeam);
      }
    });
  }

  final PageController _mainpagecontroller = PageController(initialPage: 0);
  final PageController _pageController2 = PageController(initialPage: 1);
  int _currentPage = 0;
  bool bottombarVisible = true;
  void _changePage(int page) {
    //Anasayfaya basıldığında
    if (page.toString() == "0") {
      setState(() {
        _pageController2.jumpToPage(
          1,
          // duration: const Duration(milliseconds: 300),
          // curve: Curves.ease,
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
        // duration: const Duration(milliseconds: 300),
        // curve: Curves.ease,
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
                AppUser.displayName,
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(AppUser.mail,
                  style: const TextStyle(color: Colors.white)),
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
                      visible: widgetmyGroups.isEmpty ? false : true,
                      child: ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.group, color: ARMOYU.textColor),
                        title: const Text('Gruplarım'),
                        children: widgetmyGroups,
                      ),
                    ),
                    Visibility(
                      visible: widgetmySchools.isEmpty ? false : true,
                      child: ExpansionTile(
                        textColor: ARMOYU.textColor,
                        leading: Icon(Icons.school, color: ARMOYU.textColor),
                        title: const Text('Okullarım'),
                        children: widgetmySchools,
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
                                    builder: (context) =>
                                        const RestourantPage()));
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
          favteamSelection();
        },
        children: [
          PageView(
            controller: _pageController2,
            children: [
              const CameraScreen(),
              SocialPage(homepageScrollController: homepageScrollController),
            ],
          ),
          SearchPage(
              appbar: true, searchController: appbarSearchTextController),
          const NotificationPage(),
          ProfilePage(userID: AppUser.ID, appbar: false),
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
