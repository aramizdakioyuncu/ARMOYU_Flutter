import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/group.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/school.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/station.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/team.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/socail_page/views/social_page.dart';
import 'package:ARMOYU/app/modules/utils/camera/views/cam_view.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/station/station_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/my_group_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/utils/my_school_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_widgets/functions/functions.dart';
import 'package:armoyu_widgets/functions/functions_service.dart';
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late Function(int) changePageFunction;
  @override
  void onInit() {
    super.onInit();

    if (!firstProcces.value) {
      firstProcces.value = true;
    }

    final pagesController = Get.find<PagesController>(
      tag: currentUserAccount.user.value.userID.toString(),
    );

    // ((Önemli))
    changePageFunction = pagesController.changePage;
    currentUserAccounts.value = currentUserAccount;

    if (ARMOYU.cameras!.isNotEmpty) {
      mainsocialpages.add(const CamView());
      socailinitpage.value = 1;
    }

    mainsocialpages.add(
      SocialPage(homepageScrollController: homepageScrollControllerv2.value),
    );

    //Takımları Çek opsiyonel
    ARMOYUFunctions functions = ARMOYUFunctions(
      service: API.service,
      currentUserAccounts: currentUserAccounts.value!,
    );
    functions.favteamfetch();
    //Grup Oluştur ekle

    //Grupları Çek
    loadMyGroups(currentUserAccounts.value!.user.value);
  }

  void openDrawer() {
    // Scaffold.of(Get.context!).openDrawer();
    scaffoldKey.currentState?.openDrawer();
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
    ServiceResult response =
        await API.service.profileServices.selectfavteam(teamID: team.teamID);
    if (!response.status) {
      log(response.description.toString());
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
    FunctionService f = FunctionService(API.service);
    APIMyGroupListResponse response = await f.myGroups();
    if (!response.result.status) {
      log(response.result.description.toString());
      loadGroupProcess.value = false;
      return;
    }
    if (response.response!.isEmpty) {
      currentUser.myGroups = [];
      loadGroupProcess.value = false;
      return;
    }

    drawermygroup.value = true;
    currentUser.myGroups = [];

    widgetGroups.value = [];

    for (APIMyGroupList element in response.response!) {
      Group groupfetch = Group(
        groupID: element.groupID,
        groupName: element.groupName,
        groupshortName: element.groupShortName,
        groupUsersCount: element.groupUserCount,
        joinStatus: element.groupJoinStatus == 1 ? true.obs : false.obs,
        description: element.groupDescription,
        groupSocial: GroupSocial(
          discord: element.groupSocial.groupDiscord,
          web: element.groupSocial.groupWebsite,
        ),
        groupLogo: Media(
          mediaID: 0,
          mediaType: MediaType.image,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element.groupLogo.mediaURL.bigURL),
            normalURL: Rx<String>(element.groupLogo.mediaURL.normalURL),
            minURL: Rx<String>(element.groupLogo.mediaURL.minURL),
          ),
        ),
        groupBanner: Media(
          mediaID: 0,
          mediaType: MediaType.image,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element.groupBanner.mediaURL.bigURL),
            normalURL: Rx<String>(element.groupBanner.mediaURL.normalURL),
            minURL: Rx<String>(element.groupBanner.mediaURL.minURL),
          ),
        ),
        myRole: GroupRoles(
          owner: element.groupMyRole.owner == 1 ? true : false,
          userInvite: element.groupMyRole.userInvite == 1 ? true : false,
          userKick: element.groupMyRole.userKick == 1 ? true : false,
          userRole: element.groupMyRole.userRole == 1 ? true : false,
          groupSettings: element.groupMyRole.groupSettings == 1 ? true : false,
          groupFiles: element.groupMyRole.groupFiles == 1 ? true : false,
          groupEvents: element.groupMyRole.groupEvents == 1 ? true : false,
          groupRole: element.groupMyRole.groupRole == 1 ? true : false,
          groupSurvey: element.groupMyRole.groupSurvey == 1 ? true : false,
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
    FunctionService f = FunctionService(API.service);
    APIMySchoolListResponse response = await f.mySchools();
    if (!response.result.status) {
      loadmySchoolProcess.value = false;
      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      await loadMySchools(currentUser);
      return;
    }

    if (response.response!.isEmpty) {
      loadmySchoolProcess.value = false;
      return;
    }

    drawermyschool.value = true;

    widgetSchools.value = [];
    //Kişi belleğine de kaydet
    currentUser.mySchools = [];

    for (APIMySchoolList element in response.response!) {
      School fetchSchool = School(
        schoolID: element.schoolID,
        schoolName: element.schoolName,
        schoolUsersCount: element.schoolUserCount,
        schoolLogo: Media(
          mediaID: 0,
          mediaType: MediaType.image,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element.schoolLogo.mediaURL.bigURL),
            normalURL: Rx<String>(element.schoolLogo.mediaURL.normalURL),
            minURL: Rx<String>(element.schoolLogo.mediaURL.minURL),
          ),
        ),
        schoolBanner: Media(
          mediaID: 0,
          mediaType: MediaType.image,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element.schoolBanner.mediaURL.bigURL),
            normalURL: Rx<String>(element.schoolBanner.mediaURL.normalURL),
            minURL: Rx<String>(element.schoolBanner.mediaURL.minURL),
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

    StationFetchListResponse response =
        await API.service.stationServices.fetchStations();
    if (!response.result.status) {
      log(response.result.description);
      loadfoodStationProcess.value = false;
      return;
    }
    widgetStations.value = [];

    for (APIStationList element in response.response!) {
      widgetStations.value!.add(
        Station(
          stationID: element.stationID,
          name: element.stationName,
          type: element.stationType,
          logo: Media(
            mediaID: element.stationID,
            mediaType: MediaType.image,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.stationLogo.mediaURL.bigURL),
              normalURL: Rx<String>(element.stationLogo.mediaURL.normalURL),
              minURL: Rx<String>(element.stationLogo.mediaURL.minURL),
            ),
          ),
          banner: Media(
            mediaID: element.stationID,
            mediaType: MediaType.image,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.stationBanner.mediaURL.bigURL),
              normalURL: Rx<String>(element.stationBanner.mediaURL.normalURL),
              minURL: Rx<String>(element.stationBanner.mediaURL.minURL),
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
            Get.toNamed("/group/detail", arguments: {
              "currentUserAccounts": currentUserAccounts.value!,
              "group": group,
              "groupID": group.groupID!,
            });
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
            Get.toNamed("/school", arguments: {
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

            Get.toNamed("/restourant", arguments: {
              "cafe": foodStation,
              "currentUser": currentUserAccounts.value!.user.value,
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
            Get.toNamed("/restourant", arguments: {"cafe": gameStation});
          },
        );
      },
    );
  }
}
