import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/modules/Business/applications_page/views/applications_page.dart';
import 'package:ARMOYU/app/modules/Events/list_event_page/views/eventlist_page.dart';
import 'package:ARMOYU/app/modules/Invite/invite_page/views/invite_page.dart';
import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/views/profile_page.dart';
import 'package:ARMOYU/app/modules/School/login_school_page/views/school_login.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/search_page/views/search_page.dart';
import 'package:ARMOYU/app/modules/Settings/_main/views/settings_page.dart';
import 'package:ARMOYU/app/modules/Survey/list_survey_page/views/surveylist_page.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:ARMOYU/app/theme/app_theme.dart';
import 'package:ARMOYU/app/widgets/text.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/app/Services/Utility/barcode.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../Notification/notification_page/views/notification_page.dart';

class MainPageView extends StatelessWidget {
  final UserAccounts currentUserAccounts;

  const MainPageView({
    super.key,
    required this.currentUserAccounts,
  });

  @override
  Widget build(BuildContext context) {
    // final ScrollController homepageScrollController = ScrollController();
    final ScrollController searchScrollController =
        ScrollController(initialScrollOffset: 0);
    final ScrollController notificationScrollController =
        ScrollController(initialScrollOffset: 0);
    final ScrollController profileScrollController =
        ScrollController(initialScrollOffset: 0);

    final controller = Get.put(
      MainPageController(
        // homepageScrollController: homepageScrollController,
        notificationScrollController: notificationScrollController,
        profileScrollController: profileScrollController,
        searchScrollController: searchScrollController,
        // socailpageController: socailpageController,
        currentUserAccount: currentUserAccounts,
      ),
      tag: currentUserAccounts.user.userID.toString(),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        controller.popfunction();
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: ARMOYU.backgroundcolor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Obx(
              () => Visibility(
                visible: controller.isBottomNavbarVisible.value,
                child: AppBar(
                  // backgroundColor: ARMOYU.appbarColor,
                  elevation: 0,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: controller.currentUserAccounts.value!.user
                                          .avatar ==
                                      null
                                  ? Shimmer.fromColors(
                                      baseColor: ARMOYU.baseColor,
                                      highlightColor: ARMOYU.highlightColor,
                                      child: const CircleAvatar(),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: controller.currentUserAccounts
                                          .value!.user.avatar!.mediaURL.minURL,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  title: Visibility(
                    visible: controller.appbarSearch.value,
                    child: Container(
                      // height: 50,
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: controller.appbarSearchTextController.value,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 18,
                          ),
                          hintText: 'Ara',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Obx(
                      () => IconButton(
                        icon: Badge(
                          isLabelVisible: controller.currentUserAccounts.value!
                                      .chatNotificationCount !=
                                  0
                              ? true
                              : false,
                          label: Text(
                            controller.currentUserAccounts.value!
                                .chatNotificationCount
                                .toString(),
                          ),
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          child: const Icon(
                            Icons.chat_bubble_rounded,
                          ),
                        ),
                        onPressed: () {
                          controller.changePageFunction(1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.black,
            child: Column(
              children: [
                Obx(
                  () => UserAccountsDrawerHeader(
                    margin: EdgeInsets.zero,
                    accountName: controller
                                .currentUserAccounts.value!.user.displayName ==
                            null
                        ? Shimmer.fromColors(
                            baseColor: ARMOYU.baseColor,
                            highlightColor: ARMOYU.highlightColor,
                            child: const SizedBox(width: 20),
                          )
                        : Text(
                            controller
                                .currentUserAccounts.value!.user.displayName!,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    accountEmail:
                        controller.currentUserAccounts.value!.user.userMail ==
                                null
                            ? Shimmer.fromColors(
                                baseColor: ARMOYU.baseColor,
                                highlightColor: ARMOYU.highlightColor,
                                child: const SizedBox(
                                  width: 20,
                                ),
                              )
                            : Text(
                                controller
                                    .currentUserAccounts.value!.user.userMail!,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child:
                          controller.currentUserAccounts.value!.user.avatar ==
                                  null
                              ? Shimmer.fromColors(
                                  baseColor: ARMOYU.baseColor,
                                  highlightColor: ARMOYU.highlightColor,
                                  child: const CircleAvatar(),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    controller.currentUserAccounts.value!.user
                                        .avatar!.mediaURL.minURL,
                                  ),
                                ),
                    ),
                    currentAccountPictureSize: const Size.square(75),
                    decoration:
                        controller.currentUserAccounts.value!.user.banner ==
                                null
                            ? null
                            : BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    controller.currentUserAccounts.value!.user
                                        .banner!.mediaURL.minURL,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Obx(
                          () => Visibility(
                            visible: controller.currentUserAccounts.value!.user
                                    .role!.roleID ==
                                0,
                            child: ListTile(
                              leading: const Icon(Icons.group),
                              title: const Text("Toplantı"),
                              onTap: () {},
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.article),
                          title: const Text("Haberler"),
                          onTap: () {
                            Get.toNamed("/news", arguments: {
                              "user":
                                  controller.currentUserAccounts.value!.user,
                            });
                          },
                        ),
                        ExpansionTile(
                          leading: const Icon(
                            Icons.group,
                          ),
                          title: const Text('Gruplarım'),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermygroup.value) {
                                await controller.loadMyGroups(
                                    controller.currentUserAccounts.value!.user);
                              }
                            }
                          },
                          children: [
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: const Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                              ),
                              title: const Text("Grup Oluştur"),
                              onTap: () {
                                Get.toNamed("/group/create", arguments: {
                                  "user":
                                      controller.currentUserAccounts.value!.user
                                });
                              },
                            ),
                            Obx(
                              () {
                                return Column(
                                  children: controller.generateGroupTiles(),
                                );
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: const Icon(
                            Icons.school,
                          ),
                          title: const Text('Okullarım'),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermyschool.value) {
                                await controller.loadMySchools(
                                    controller.currentUserAccounts.value!.user);
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
                                Get.to(const SchoolLoginPageView(), arguments: {
                                  "currentUser": controller
                                      .currentUserAccounts.value!.user,
                                });
                              },
                            ),
                            Obx(
                              () {
                                return Column(
                                  children: controller.generateSchoolTiles(),
                                );
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: const Icon(
                            Icons.local_drink,
                          ),
                          title: const Text('Yemek'),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermyfood.value) {
                                await controller.loadFoodStation(
                                    controller.currentUserAccounts.value!.user);
                              }
                            }
                          },
                          children: [
                            Obx(
                              () {
                                return Column(
                                  children:
                                      controller.generateFoodStationTiles(),
                                );
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          leading: const Icon(
                            Icons.videogame_asset_rounded,
                          ),
                          title: const Text('Oyun'),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermyfood.value) {
                                await controller.loadFoodStation(
                                    controller.currentUserAccounts.value!.user);
                              }
                            }
                          },
                          children: [
                            Obx(
                              () {
                                return Column(
                                  children:
                                      controller.generateGameStationTiles(),
                                );
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          leading: const Icon(Icons.event),
                          title: const Text("Etkinlikler"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventlistPage(
                                  currentUserAccounts:
                                      controller.currentUserAccounts.value!,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.analytics_rounded),
                          title: const Text("Anketler"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SurveyListPage(
                                  currentUserAccounts:
                                      controller.currentUserAccounts.value!,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.assignment_sharp),
                          title: const Text("Davet Et"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvitePage(
                                  currentUserAccounts:
                                      controller.currentUserAccounts.value!,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business_center),
                          title: const Text("Bize Katıl"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusinessApplicationsView(
                                  currentUser: controller
                                      .currentUserAccounts.value!.user,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text("Ayarlar"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(
                                  currentUser: controller
                                      .currentUserAccounts.value!.user,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.nightlight,
                            ),
                            onPressed: () {
                              if (Get.isDarkMode) {
                                Get.changeTheme(appThemeData);
                              } else {
                                Get.changeTheme(ThemeData.dark());
                              }
                            },
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.qr_code_2_rounded,
                            ),
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
            controller: controller.mainpagecontroller.value,
            onPageChanged: (int page) {
              ARMOYUFunctions functions = ARMOYUFunctions(
                currentUserAccounts: controller.currentUserAccounts.value!,
              );
              functions.selectFavTeam(context);
            },
            children: [
              Obx(
                () => PageView(
                  controller: controller.socailpageController.value,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: (value) {
                    log(controller.socailpageController.value.initialPage
                        .toString());
                    if (value == 0 && controller.mainsocialpages.length != 1) {
                      controller.isBottomNavbarVisible.value = false;
                    } else {
                      controller.isBottomNavbarVisible.value = true;
                    }
                  },
                  children: controller.mainsocialpages,
                ),
              ),
              Obx(
                () => SearchPage(
                  currentUserAccounts: controller.currentUserAccounts.value!,
                  appbar: true,
                  scrollController: searchScrollController,
                ),
              ),
              Obx(
                () => NotificationPage(
                  currentUserAccounts: controller.currentUserAccounts.value!,
                  scrollController: notificationScrollController,
                ),
              ),
              Obx(
                () => ProfileView(
                  currentUserAccounts: controller.currentUserAccounts.value!,
                  profileScrollController: profileScrollController,
                ),
              )
            ],
          ),
          bottomNavigationBar: Obx(
            () => Visibility(
              visible: controller.isBottomNavbarVisible.value,
              child: BottomNavigationBar(
                onTap: (value) {
                  controller.changePage(value);
                },
                currentIndex: controller.currentPage.value,
                // backgroundColor: ARMOYU.appbarColor,
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
                      isLabelVisible: (controller
                                  .currentUserAccounts.value!.groupInviteCount +
                              controller.currentUserAccounts.value!
                                  .friendRequestCount) >
                          0,
                      label: Text(
                        (controller.currentUserAccounts.value!
                                    .groupInviteCount +
                                controller.currentUserAccounts.value!
                                    .friendRequestCount)
                            .toString(),
                      ),
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      child: const Icon(
                        Icons.notifications,
                      ),
                    ),
                    label: 'Bildirimler',
                  ),
                  BottomNavigationBarItem(
                    icon: GestureDetector(
                      onLongPress: () {
                        // return;
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
                                body: SingleChildScrollView(
                                  child: SafeArea(
                                    child: Column(
                                      children: [
                                        ...List.generate(ARMOYU.appUsers.length,
                                            (index) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              foregroundImage:
                                                  CachedNetworkImageProvider(
                                                ARMOYU.appUsers[index].user
                                                    .avatar!.mediaURL.minURL,
                                              ),
                                            ),
                                            title: CustomText.costum1(
                                              ARMOYU.appUsers[index].user
                                                  .displayName
                                                  .toString(),
                                            ),
                                            onTap: () {
                                              final controller2 =
                                                  Get.put(AppPageController());

                                              controller2.changeAccount(
                                                ARMOYU.appUsers[index],
                                              );
                                            },
                                          );
                                        }),
                                        ListTile(
                                          leading: const Icon(
                                              Icons.person_add_rounded),
                                          title: CustomText.costum1(
                                            "Hesap Ekle",
                                            color: Colors.blue,
                                          ),
                                          onTap: () async {
                                            final result = await Get.toNamed(
                                                "/login",
                                                arguments: {
                                                  "currentUser": controller
                                                      .currentUserAccounts
                                                      .value!
                                                      .user,
                                                  "accountAdd": true,
                                                });

                                            if (result != null) {
                                              log(result.toString());
                                            }
                                          },
                                        ),
                                      ],
                                    ),
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
                        // textColor: ARMOYU.appbarColor,
                        child: const Icon(Icons.person),
                      ),
                    ),
                    label: 'Profil',
                  ),
                ],
                selectedItemColor: ARMOYU.color,
                unselectedItemColor: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
