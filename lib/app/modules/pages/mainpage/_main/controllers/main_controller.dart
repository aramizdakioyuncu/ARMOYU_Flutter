import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/team.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/functions/API_Functions/station.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/Restourant/restourant_page/views/restourant_page.dart';
import 'package:ARMOYU/app/modules/School/school_page/views/school_page.dart';
import 'package:ARMOYU/app/modules/Utility/camera_screen_page.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/socail_page/views/social_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  final ScrollController notificationScrollController;
  final ScrollController profileScrollController;
  final ScrollController searchScrollController;
  final UserAccounts currentUserAccount;

  MainPageController({
    required this.notificationScrollController,
    required this.profileScrollController,
    required this.searchScrollController,
    required this.currentUserAccount,
  });

  var homepageScrollControllerv2 = ScrollController().obs;
  var socailinitpage = 0.obs;
  late var socailpageController =
      PageController(initialPage: socailinitpage.value).obs;
  var mainsocialpages = <Widget>[].obs;

  var mainpagecontroller = PageController(initialPage: 0).obs;

  late var currentUserAccounts = Rxn<UserAccounts>();

  var isBottomNavbarVisible = true.obs;

  var postpage = 1.obs;
  var postpageproccess = false.obs;
  var isRefreshing = false.obs;
  var firstProcces = false.obs;

  var appbarSearchTextController = TextEditingController().obs;
  var appbarSearch = false.obs;

  var widgetGroups = Rxn<List<Group>>(null);
  var drawermygroup = false.obs;
  var loadGroupProcess = false.obs;

  var widgetSchools = Rxn<List<School>>(null);
  var drawermyschool = false.obs;
  var loadmySchoolProcess = false.obs;

  var widgetStations = Rxn<List<Station>>(null);

  var widgetFoodStation = Rxn<List<Station>>(null);
  var drawermyfood = false.obs;
  var loadfoodStationProcess = false.obs;

  var widgetGameStation = Rxn<List<Station>>(null);

  late Function(int) changePageFunction;
  @override
  void onInit() {
    super.onInit();

    if (!firstProcces.value) {
      firstProcces.value = true;
    }

    final pagesController = Get.find<PagesController>(
      tag: currentUserAccount.user.userID.toString(),
    );

    // ((Önemli))
    changePageFunction = pagesController.changePage;
    currentUserAccounts.value = currentUserAccount;

    if (ARMOYU.cameras!.isNotEmpty) {
      mainsocialpages.add(
        CameraScreen(
          currentUser: currentUserAccounts.value!.user,
          canPop: false,
        ),
      );
      socailinitpage.value = 1;
    }

    mainsocialpages.add(
      SocialPage(
        currentUserAccounts: currentUserAccounts.value!,
        homepageScrollController: homepageScrollControllerv2.value,
      ),
    );

    //Takımları Çek opsiyonel
    ARMOYUFunctions functions = ARMOYUFunctions(
      currentUserAccounts: currentUserAccounts.value!,
    );
    functions.favteamfetch();
    //Grup Oluştur ekle

    //Grupları Çek
    loadMyGroups(currentUserAccounts.value!.user);
  }

  void popfunction() {
    currentPage.value = 0;
    mainpagecontroller.value.jumpToPage(
      0,
    );

    try {
      socailpageController.value.jumpToPage(1);
    } catch (e) {
      log(e.toString());
    }
  }

  void changePage(int page) {
    //Anasayfaya basıldığında
    if (page.toString() == "0") {
      // socailpageController.jumpToPage(1);

      //Anasayfa butonuna anasayfadaykan basarsan en üstte çıkartan kod
      if (currentPage.value.toString() == "0") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            homepageScrollControllerv2.value.animateTo(
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
      if (currentPage.value.toString() == "1") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            searchScrollController.animateTo(
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
      if (currentPage.value.toString() == "2") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            notificationScrollController.animateTo(
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
      if (currentPage.value.toString() == "3") {
        try {
          Future.delayed(const Duration(milliseconds: 100), () {
            profileScrollController.animateTo(
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
      appbarSearch.value = true;
    } else {
      appbarSearch.value = false;
    }

    currentPage.value = page;
    mainpagecontroller.value.jumpToPage(
      page,
    );
  }

  Future<void> favteamselect(User currentUser, Team team) async {
    FunctionsProfile f = FunctionsProfile(currentUser: currentUser);
    Map<String, dynamic> response = await f.selectfavteam(team.teamID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }

    currentUser.favTeam = Team(
      teamID: team.teamID,
      name: team.name,
      logo: team.logo,
    );
  }

  var currentPage = 0.obs;
  var bottombarVisible = true.obs;

  Future<void> loadMyGroups(User currentUser) async {
    if (loadGroupProcess.value) {
      return;
    }

    loadGroupProcess.value = true;
    FunctionService f = FunctionService(currentUser: currentUser);
    Map<String, dynamic> response = await f.myGroups();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      loadGroupProcess.value = false;
      return;
    }
    if (response["icerik"].length == 0) {
      currentUser.myGroups = [];
      loadGroupProcess.value = false;
      return;
    }

    drawermygroup.value = true;
    currentUser.myGroups = [];

    widgetGroups.value = [];

    for (dynamic element in response["icerik"]) {
      Group groupfetch = Group(
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
            bigURL: Rx<String>(element['group_logo']['media_bigURL']),
            normalURL: Rx<String>(element['group_logo']['media_URL']),
            minURL: Rx<String>(element['group_logo']['media_minURL']),
          ),
        ),
        groupBanner: Media(
          mediaID: 0,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element['group_banner']['media_bigURL']),
            normalURL: Rx<String>(element['group_banner']['media_URL']),
            minURL: Rx<String>(element['group_banner']['media_minURL']),
          ),
        ),
        myRole: GroupRoles(
          owner: element['group_myRole']['owner'] == 1 ? true : false,
          userInvite:
              element['group_myRole']['user_invite'] == 1 ? true : false,
          userKick: element['group_myRole']['user_kick'] == 1 ? true : false,
          userRole: element['group_myRole']['user_role'] == 1 ? true : false,
          groupSettings:
              element['group_myRole']['group_settings'] == 1 ? true : false,
          groupFiles:
              element['group_myRole']['group_files'] == 1 ? true : false,
          groupEvents:
              element['group_myRole']['group_events'] == 1 ? true : false,
          groupRole: element['group_myRole']['group_role'] == 1 ? true : false,
          groupSurvey:
              element['group_myRole']['group_survey'] == 1 ? true : false,
        ),
      );
      currentUser.myGroups!.add(groupfetch);
      widgetGroups.value!.add(groupfetch);
    }
  }

  Future<void> loadMySchools(User currentUser) async {
    if (loadmySchoolProcess.value) {
      return;
    }
    loadmySchoolProcess.value = true;
    FunctionService f = FunctionService(currentUser: currentUser);
    Map<String, dynamic> response = await f.mySchools();
    if (response["durum"] == 0) {
      loadmySchoolProcess.value = false;
      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      await loadMySchools(currentUser);
      return;
    }

    if (response["icerik"].length == 0) {
      loadmySchoolProcess.value = false;
      return;
    }

    drawermyschool.value = true;

    widgetSchools.value = [];
    //Kişi belleğine de kaydet
    currentUser.mySchools = [];

    for (int i = 0; i < response["icerik"].length; i++) {
      School fetchSchool = School(
        schoolID: response["icerik"][i]["school_ID"],
        schoolName: response["icerik"][i]["school_name"],
        schoolUsersCount: response["icerik"][i]["school_uyesayisi"],
        schoolLogo: Media(
          mediaID: 0,
          mediaURL: MediaURL(
            bigURL: Rx<String>(
                response["icerik"][i]["school_logo"]["media_bigURL"]),
            normalURL:
                Rx<String>(response["icerik"][i]["school_logo"]["media_URL"]),
            minURL: Rx<String>(
                response["icerik"][i]["school_logo"]["media_minURL"]),
          ),
        ),
        schoolBanner: Media(
          mediaID: 0,
          mediaURL: MediaURL(
            bigURL: Rx<String>(
                response["icerik"][i]["school_banner"]["media_bigURL"]),
            normalURL:
                Rx<String>(response["icerik"][i]["school_banner"]["media_URL"]),
            minURL: Rx<String>(
                response["icerik"][i]["school_banner"]["media_minURL"]),
          ),
        ),
      );

      //Veri Ekle
      currentUser.mySchools!.add(fetchSchool);
      widgetSchools.value!.add(fetchSchool);
      //Veri Ekle Bitiş
    }
    loadmySchoolProcess.value = false;
  }

  Future<void> loadFoodStation(User currentUser) async {
    if (loadfoodStationProcess.value) {
      return;
    }
    loadfoodStationProcess.value = true;

    FunctionsStation f = FunctionsStation(currentUser: currentUser);
    Map<String, dynamic> response = await f.fetchStations();
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      loadfoodStationProcess.value = false;
      return;
    }
    widgetStations.value = [];

    for (dynamic element in response["icerik"]) {
      widgetStations.value!.add(
        Station(
          stationID: element["station_ID"],
          name: element["station_name"],
          type: element["station_type"],
          logo: Media(
            mediaID: element["station_ID"],
            mediaURL: MediaURL(
              bigURL: Rx<String>(element["station_logo"]["media_bigURL"]),
              normalURL: Rx<String>(element["station_logo"]["media_URL"]),
              minURL: Rx<String>(element["station_logo"]["media_minURL"]),
            ),
          ),
          banner: Media(
            mediaID: element["station_ID"],
            mediaURL: MediaURL(
              bigURL: Rx<String>(element["station_banner"]["media_bigURL"]),
              normalURL: Rx<String>(element["station_banner"]["media_URL"]),
              minURL: Rx<String>(element["station_banner"]["media_minURL"]),
            ),
          ),
        ),
      );
    }

    widgetFoodStation.value = widgetStations.value!.where((item) {
      return item.type.toLowerCase().contains("yemek");
    }).toList();

    widgetGameStation.value = widgetStations.value!.where((item) {
      return item.type.toLowerCase().contains("cafe");
    }).toList();

    drawermyfood.value = true;
    loadfoodStationProcess.value = false;
  }

//Widgets  //Widgets  //Widgets  //Widgets  //Widgets  //Widgets  //Widgets

  List<Widget> generateGroupTiles() {
    if (widgetGroups.value == null) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CupertinoActivityIndicator(),
        ),
      ];
    }

    if (widgetGroups.value!.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Henüz bir grubunuz yok."),
        ),
      ];
    }

    return List.generate(
      widgetGroups.value!.length,
      (index) {
        var group = widgetGroups.value![index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: group.groupLogo!.mediaURL.minURL.value,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(group.groupName!),
          onTap: () {
            Get.toNamed("/group", arguments: {
              "currentUserAccounts": currentUserAccounts.value!,
              "group": group,
              "groupID": group.groupID!,
            });
            // Get.to(
            //   () => GroupPage(
            //     currentUserAccounts: currentUserAccounts.value!,
            //     group: group,
            //     groupID: group.groupID!,
            //   ),
            // );
          },
        );
      },
    );
  }

  List<Widget> generateSchoolTiles() {
    if (widgetSchools.value == null ||
        widgetSchools.value!.isEmpty && loadmySchoolProcess.value) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CupertinoActivityIndicator(),
        ),
      ];
    }

    return List.generate(
      widgetSchools.value?.length ?? 0,
      (index) {
        var school = widgetSchools.value![index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: school.schoolLogo!.mediaURL.minURL.value,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(school.schoolName!),
          onTap: () {
            Get.to(const SchoolPageView(), arguments: {
              "user": currentUserAccounts.value!.user,
              "school": school,
              "schoolID": school.schoolID!,
            });
          },
        );
      },
    );
  }

  List<Widget> generateFoodStationTiles() {
    if (widgetFoodStation.value == null) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CupertinoActivityIndicator(),
        ),
      ];
    }

    return List.generate(
      widgetFoodStation.value!.length,
      (index) {
        var foodStation = widgetFoodStation.value![index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: foodStation.logo.mediaURL.minURL.value,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(foodStation.name),
          onTap: () {
            // Restoran sayfasına yönlendirme işlemleri yapılabilir
            // Get.to(() => RestourantPage(cafe: foodStation, currentUser: currentUser));

            Get.to(
                RestourantPageView(
                  cafe: foodStation,
                  currentUser: currentUserAccounts.value!.user,
                ),
                arguments: {
                  "cafe": foodStation,
                  "currentUser": currentUserAccounts.value!.user,
                });
          },
        );
      },
    );
  }

  List<Widget> generateGameStationTiles() {
    if (widgetGameStation.value == null) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CupertinoActivityIndicator(),
        ),
      ];
    }

    return List.generate(
      widgetGameStation.value!.length,
      (index) {
        var gameStation = widgetGameStation.value![index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: gameStation.logo.mediaURL.minURL.value,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(gameStation.name),
          onTap: () {
            // Burada sayfa yönlendirme işlemleri yapılabilir
            // Get.to(() => RestourantPage(cafe: gameStation, currentUser: currentUser));
          },
        );
      },
    );
  }
}
