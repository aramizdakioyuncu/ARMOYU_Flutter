import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Functions/API_Functions/station.dart';
import 'package:ARMOYU/Functions/functions.dart';
import 'package:ARMOYU/Models/group.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/school.dart';
import 'package:ARMOYU/Models/station.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Business/applications_page.dart';
import 'package:ARMOYU/Screens/Events/eventlist_page.dart';
import 'package:ARMOYU/Screens/Group/group_create.dart';
import 'package:ARMOYU/Screens/Group/group_page.dart';
import 'package:ARMOYU/Screens/Invite/invite_page.dart';
import 'package:ARMOYU/Screens/LoginRegister/login_page.dart';
import 'package:ARMOYU/Screens/News/news_list.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Screens/Restourant/restourant_page.dart';
import 'package:ARMOYU/Screens/School/school_login.dart';
import 'package:ARMOYU/Screens/School/school_page.dart';
import 'package:ARMOYU/Screens/Search/search_page.dart';
import 'package:ARMOYU/Screens/Settings/settings_page.dart';
import 'package:ARMOYU/Screens/Survey/surveylist_page.dart';
import 'package:ARMOYU/Screens/Utility/camera_screen_page.dart';
import 'package:ARMOYU/Screens/app_page.dart';
import 'package:ARMOYU/Screens/pages.dart';
import 'package:ARMOYU/Widgets/text.dart';
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
  final User? currentUser;

  final dynamic changePage;

  const MainPage({
    super.key,
    required this.currentUser,
    required this.changePage,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

bool _isBottomNavbarVisible = true;

bool _appbarSearch = false;

int postpage = 1;
bool postpageproccess = false;
bool isRefreshing = false;
bool firstProcces = false;

final TextEditingController appbarSearchTextController =
    TextEditingController();

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  final PageController _mainpagecontroller = PageController(initialPage: 0);
  final PageController _socailpageController = PageController(initialPage: 1);

  List<Station> widgetStations = [];
  List<Station> widgetFoodStation = [];
  List<Station> widgetGameStation = [];

  bool _drawermyschool = false;
  bool _drawermygroup = false;
  bool _drawermyfood = false;

  @override
  bool get wantKeepAlive => true;

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

    //Grupları Çek
    loadMyGroups();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> favteamselect(Team team) async {
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.selectfavteam(team.teamID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    widget.currentUser!.favTeam = Team(
      teamID: team.teamID,
      name: team.name,
      logo: team.logo,
    );
  }

  int _currentPage = 0;
  bool bottombarVisible = true;
  void _changePage(int page) {
    //Anasayfaya basıldığında
    if (page.toString() == "0") {
      setState(() {
        _socailpageController.jumpToPage(
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
        _appbarSearch = true;
      });
    } else {
      setState(() {
        _appbarSearch = false;
      });
    }

    setState(() {
      _currentPage = page;
      _mainpagecontroller.jumpToPage(
        page,
      );
    });
  }

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
      widget.currentUser!.myGroups = [];
      loadGroupProcess = false;
      return;
    }

    _drawermygroup = true;
    widget.currentUser!.myGroups = [];
    for (dynamic element in response["icerik"]) {
      widget.currentUser!.myGroups!.add(
        Group(
            groupID: element['group_ID'],
            groupName: element['group_name'],
            groupshortName: element['group_shortname'],
            groupUsersCount: element['group_usercount'],
            joinStatus: element['group_joinstatus'] == 1 ? true : false,
            description: element['group_description'],
            groupSocial: GroupSocial(
              discord: element['group_social']['group_discord'],
              web: element['group_social']['group_website'],
            ),
            groupLogo: Media(
              mediaID: 0,
              mediaURL: MediaURL(
                bigURL: element['group_logo']['media_bigURL'],
                normalURL: element['group_logo']['media_URL'],
                minURL: element['group_logo']['media_minURL'],
              ),
            ),
            groupBanner: Media(
              mediaID: 0,
              mediaURL: MediaURL(
                bigURL: element['group_banner']['media_bigURL'],
                normalURL: element['group_banner']['media_URL'],
                minURL: element['group_banner']['media_minURL'],
              ),
            ),
            myRole: GroupRoles(
              owner: element['group_myRole']['owner'] == 1 ? true : false,
              userInvite:
                  element['group_myRole']['user_invite'] == 1 ? true : false,
              userKick:
                  element['group_myRole']['user_kick'] == 1 ? true : false,
              userRole:
                  element['group_myRole']['user_role'] == 1 ? true : false,
              groupSettings:
                  element['group_myRole']['group_settings'] == 1 ? true : false,
              groupFiles:
                  element['group_myRole']['group_files'] == 1 ? true : false,
              groupEvents:
                  element['group_myRole']['group_events'] == 1 ? true : false,
              groupRole:
                  element['group_myRole']['group_role'] == 1 ? true : false,
              groupSurvey:
                  element['group_myRole']['group_survey'] == 1 ? true : false,
            )),
      );
    }

    setstatefunction();
  }

  bool loadfoodStationProcess = false;

  Future<void> loadFoodStation() async {
    if (loadfoodStationProcess) {
      return;
    }
    loadfoodStationProcess = true;

    FunctionsStation f = FunctionsStation();
    Map<String, dynamic> response = await f.fetchStations();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      loadfoodStationProcess = false;
      return;
    }
    widgetStations.clear();
    for (dynamic element in response["icerik"]) {
      widgetStations.add(
        Station(
          stationID: element["station_ID"],
          name: element["station_name"],
          type: element["station_type"],
          logo: Media(
            mediaID: element["station_ID"],
            mediaURL: MediaURL(
              bigURL: element["station_logo"]["media_bigURL"],
              normalURL: element["station_logo"]["media_URL"],
              minURL: element["station_logo"]["media_minURL"],
            ),
          ),
          banner: Media(
            mediaID: element["station_ID"],
            mediaURL: MediaURL(
              bigURL: element["station_banner"]["media_bigURL"],
              normalURL: element["station_banner"]["media_URL"],
              minURL: element["station_banner"]["media_minURL"],
            ),
          ),
        ),
      );
    }

    widgetFoodStation = widgetStations.where((item) {
      return item.type.toLowerCase().contains("yemek");
    }).toList();

    widgetGameStation = widgetStations.where((item) {
      return item.type.toLowerCase().contains("cafe");
    }).toList();

    _drawermyfood = true;
    loadfoodStationProcess = false;

    setstatefunction();
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
      await loadMySchools();
      return;
    }

    if (response["icerik"].length == 0) {
      loadmySchoolProcess = false;
      return;
    }

    _drawermyschool = true;

    widget.currentUser!.mySchools = [];
    for (int i = 0; i < response["icerik"].length; i++) {
      widget.currentUser!.mySchools!.add(
        School(
          schoolID: response["icerik"][i]["school_ID"],
          schoolName: response["icerik"][i]["school_name"],
          schoolUsersCount: response["icerik"][i]["school_uyesayisi"],
          schoolLogo: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: response["icerik"][i]["school_logo"]["media_bigURL"],
              normalURL: response["icerik"][i]["school_logo"]["media_URL"],
              minURL: response["icerik"][i]["school_logo"]["media_minURL"],
            ),
          ),
          schoolBanner: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: response["icerik"][i]["school_banner"]["media_bigURL"],
              normalURL: response["icerik"][i]["school_banner"]["media_URL"],
              minURL: response["icerik"][i]["school_banner"]["media_minURL"],
            ),
          ),
        ),
      );
    }
    loadmySchoolProcess = false;
    setstatefunction();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        setState(() {
          _currentPage = 0;
          _mainpagecontroller.jumpToPage(
            0,
          );
          _socailpageController.jumpToPage(1);
        });
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          // backgroundColor: ARMOYU.backgroundcolor,
          appBar: !_isBottomNavbarVisible
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
                            child: widget.currentUser!.avatar == null
                                ? const SkeletonAvatar()
                                : CachedNetworkImage(
                                    imageUrl: widget
                                        .currentUser!.avatar!.mediaURL.minURL,
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
                    visible: _appbarSearch,
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
          drawer: !_isBottomNavbarVisible
              ? null
              : Drawer(
                  backgroundColor: ARMOYU.appbarColor,
                  child: Column(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: widget.currentUser!.displayName == null
                            ? const SkeletonLine(
                                style: SkeletonLineStyle(width: 20),
                              )
                            : Text(
                                widget.currentUser!.displayName!,
                                style: const TextStyle(color: Colors.white),
                              ),
                        accountEmail: widget.currentUser!.userMail == null
                            ? const SkeletonLine(
                                style: SkeletonLineStyle(width: 20),
                              )
                            : Text(
                                widget.currentUser!.userMail!,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                        currentAccountPicture: GestureDetector(
                          onTap: () {
                            _changePage(3);
                            Navigator.of(context).pop();
                          },
                          child: widget.currentUser!.avatar == null
                              ? const SkeletonAvatar()
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                      widget.currentUser!.avatar!.mediaURL
                                          .minURL),
                                ),
                        ),
                        currentAccountPictureSize: const Size.square(70),
                        decoration: widget.currentUser!.banner == null
                            ? null
                            : BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    widget.currentUser!.banner!.mediaURL.minURL,
                                  ),
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
                                          const NewslistPage(),
                                    ),
                                  );
                                },
                              ),
                              ExpansionTile(
                                textColor: ARMOYU.textColor,
                                leading:
                                    Icon(Icons.group, color: ARMOYU.textColor),
                                title: const Text('Gruplarım'),
                                onExpansionChanged: (value) async {
                                  if (value) {
                                    if (!_drawermygroup) {
                                      await loadMyGroups();
                                    }
                                  }
                                },
                                children: [
                                  ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: const Icon(Icons.add,
                                          size: 30, color: Colors.blue),
                                    ),
                                    title: const Text("Grup Oluştur"),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const GroupCreatePage(),
                                        ),
                                      );
                                    },
                                  ),
                                  widget.currentUser!.myGroups == null
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CupertinoActivityIndicator(),
                                        )
                                      : widget.currentUser!.myGroups!.isEmpty
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child:
                                                  CupertinoActivityIndicator(),
                                            )
                                          : Container(),
                                  ...List.generate(
                                      widget.currentUser!.myGroups == null
                                          ? 0
                                          : widget.currentUser!.myGroups!
                                              .length, (index) {
                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                              .currentUser!
                                              .myGroups![index]
                                              .groupLogo!
                                              .mediaURL
                                              .minURL,
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        widget.currentUser!.myGroups![index]
                                            .groupName!,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GroupPage(
                                              currentUser: widget.currentUser,
                                              group: widget.currentUser!
                                                  .myGroups![index],
                                              groupID: widget.currentUser!
                                                  .myGroups![index].groupID!,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                              ExpansionTile(
                                textColor: ARMOYU.textColor,
                                leading:
                                    Icon(Icons.school, color: ARMOYU.textColor),
                                title: const Text('Okullarım'),
                                onExpansionChanged: (value) async {
                                  if (value) {
                                    if (!_drawermyschool) {
                                      await loadMySchools();
                                    }
                                  }
                                },
                                children: [
                                  ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: const Icon(Icons.add,
                                          size: 30, color: Colors.blue),
                                    ),
                                    title: const Text("Okula Katıl"),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SchoolLoginPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  widget.currentUser!.mySchools == null ||
                                          widget.currentUser!.mySchools!
                                                  .isEmpty &&
                                              loadmySchoolProcess
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CupertinoActivityIndicator(),
                                        )
                                      : Container(),
                                  ...List.generate(
                                      widget.currentUser!.mySchools == null
                                          ? 0
                                          : widget.currentUser!.mySchools!
                                              .length, (index) {
                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                              .currentUser!
                                              .mySchools![index]
                                              .schoolLogo!
                                              .mediaURL
                                              .minURL,
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        widget.currentUser!.mySchools![index]
                                            .schoolName!,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SchoolPage(
                                              school: widget.currentUser!
                                                  .mySchools![index],
                                              schoolID: widget.currentUser!
                                                  .mySchools![index].schoolID!,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                              ExpansionTile(
                                leading: Icon(Icons.local_drink,
                                    color: ARMOYU.textColor),
                                title: const Text('Yemek'),
                                onExpansionChanged: (value) async {
                                  if (value) {
                                    if (!_drawermyfood) {
                                      await loadFoodStation();
                                    }
                                  }
                                },
                                children: widgetStations.isEmpty
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                          title: Text(
                                            widgetFoodStation[index].name,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RestourantPage(
                                                  cafe:
                                                      widgetFoodStation[index],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                              ),
                              ExpansionTile(
                                leading: Icon(
                                  Icons.videogame_asset_rounded,
                                  color: ARMOYU.textColor,
                                ),
                                title: const Text('Oyun'),
                                onExpansionChanged: (value) async {
                                  if (value) {
                                    if (!_drawermyfood) {
                                      await loadFoodStation();
                                    }
                                  }
                                },
                                children: widgetStations.isEmpty
                                    ? [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CupertinoActivityIndicator(),
                                        )
                                      ]
                                    : List.generate(widgetGameStation.length,
                                        (index) {
                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: CachedNetworkImage(
                                              imageUrl: widgetGameStation[index]
                                                  .logo
                                                  .mediaURL
                                                  .minURL,
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(
                                            widgetGameStation[index].name,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RestourantPage(
                                                  cafe:
                                                      widgetGameStation[index],
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
                                      builder: (context) => EventlistPage(
                                        currentUser: widget.currentUser,
                                      ),
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
                                      builder: (context) =>
                                          const SurveyListPage(),
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
                                leading: const Icon(Icons.business_center),
                                title: const Text("Bize Katıl"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BusinessApplicationsPage(),
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
                                      builder: (context) => SettingsPage(
                                        currentUser: widget.currentUser,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                // Sağ tarafta bir buton
                                trailing: IconButton(
                                  icon: Icon(Icons.nightlight,
                                      color: ARMOYU.textColor),
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
            physics: const NeverScrollableScrollPhysics(),
            controller: _mainpagecontroller,
            onPageChanged: (int page) {
              ARMOYUFunctions.selectFavTeam(context);
            },
            children: [
              PageView(
                controller: _socailpageController,
                physics: _socailpageController.initialPage == 0 ? null : null,
                onPageChanged: (value) {
                  log(_socailpageController.initialPage.toString());
                  if (value == 0) {
                    setState(() {
                      _isBottomNavbarVisible = false;
                    });
                  } else {
                    setState(() {
                      _isBottomNavbarVisible = true;
                    });
                  }
                },
                children: [
                  ARMOYU.cameras!.isNotEmpty
                      ? const CameraScreen(
                          canPop: false,
                        )
                      : Container(),
                  SocialPage(
                    currentUser: widget.currentUser,
                    homepageScrollController: _homepageScrollController,
                  )
                ],
              ),
              SearchPage(
                currentUser: widget.currentUser,
                appbar: true,
                searchController: appbarSearchTextController,
                scrollController: _searchScrollController,
              ),
              NotificationPage(
                currentUser: widget.currentUser,
                scrollController: _notificationScrollController,
              ),
              ProfilePage(
                ismyProfile: true,
                currentUser: User(
                  userID: widget.currentUser!.userID,
                ),
                scrollController: _profileScrollController,
              )
            ],
          ),
          bottomNavigationBar: Visibility(
            visible: _isBottomNavbarVisible,
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
                  icon: GestureDetector(
                    onLongPress: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        isScrollControlled: true,
                        backgroundColor: ARMOYU.backgroundcolor,
                        context: context,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                            heightFactor: 0.3,
                            child: Scaffold(
                              backgroundColor: ARMOYU.backgroundcolor,
                              body: SafeArea(
                                child: Column(
                                  children: [
                                    ...List.generate(ARMOYU.appUsers.length,
                                        (index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                            ARMOYU.appUsers[index].avatar!
                                                .mediaURL.minURL,
                                          ),
                                        ),
                                        title: CustomText.costum1(
                                          ARMOYU.appUsers[index].displayName
                                              .toString(),
                                        ),
                                        onTap: () async {
                                          if (!pagesViewList.any((element) =>
                                              element.currentUser!.userID ==
                                              ARMOYU.appUsers[index].userID!)) {
                                            pagesViewList.add(
                                              Pages(
                                                currentUser:
                                                    ARMOYU.appUsers[index],
                                              ),
                                            );
                                          }

                                          log(pagesViewList.length.toString());

                                          // pagescontroller.animateToPage(
                                          //   index,
                                          //   duration: const Duration(
                                          //     milliseconds: 300,
                                          //   ),
                                          //   curve: Curves.ease,
                                          // );
                                          // int countPageIndex = 0;
                                          // for (Pages element in pagesViewList) {
                                          //   element.currentUser!.userID ==
                                          //       ARMOYU.appUsers[index].userID;
                                          //       countPageIndex++;
                                          // }

                                          int countPageIndex = pagesViewList
                                              .indexWhere((element) =>
                                                  element.currentUser!.userID ==
                                                  ARMOYU
                                                      .appUsers[index].userID);
                                          pagescontroller.animateToPage(
                                            countPageIndex,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.ease,
                                          );

                                          // int countIndex = 0;
                                          // for (User element
                                          //     in ARMOYU.appUsers) {
                                          //   element.userID ==
                                          //       ARMOYU.appUsers[index].userID;
                                          //   countIndex++;
                                          // }
                                          // ARMOYU.selectedUser = countIndex;

                                          int countIndex = ARMOYU.appUsers
                                              .indexWhere((element) =>
                                                  element.userID ==
                                                  ARMOYU
                                                      .appUsers[index].userID);
                                          ARMOYU.selectedUser = countIndex;

                                          setstatefunction();
                                          if (mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      );
                                    }),
                                    ListTile(
                                      leading:
                                          const Icon(Icons.person_add_rounded),
                                      title: CustomText.costum1(
                                        "Hesap Ekle",
                                        color: Colors.blue,
                                      ),
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(
                                              accountAdd: true,
                                            ),
                                          ),
                                        );

                                        if (result != null) {
                                          log(result.toString());
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Badge(
                      isLabelVisible: false,
                      label: const Text("1"),
                      backgroundColor: ARMOYU.color,
                      textColor: ARMOYU.appbarColor,
                      child: const Icon(Icons.person),
                    ),
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
