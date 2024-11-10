import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/modules/Events/list_event_page/views/eventlist_page.dart';
import 'package:ARMOYU/app/modules/apppage/controllers/app_page_controller.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/views/profile_page.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/search_page/views/search_page.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/app/Services/Utility/barcode.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../Notification/_main/views/notification_page.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    final ScrollController searchScrollController =
        ScrollController(initialScrollOffset: 0);
    final ScrollController notificationScrollController =
        ScrollController(initialScrollOffset: 0);
    final ScrollController profileScrollController =
        ScrollController(initialScrollOffset: 0);

    final controller = Get.put(
      MainPageController(
        notificationScrollController: notificationScrollController,
        profileScrollController: profileScrollController,
        searchScrollController: searchScrollController,
        currentUserAccount:
            findCurrentAccountController.currentUserAccounts.value,
      ),
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );

    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        controller.popfunction();
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Obx(
              () => Visibility(
                visible: controller.isBottomNavbarVisible.value,
                child: AppBar(
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
                                          .value.avatar ==
                                      null
                                  ? Shimmer.fromColors(
                                      baseColor: Get.theme.disabledColor,
                                      highlightColor: Get.theme.highlightColor,
                                      child: const CircleAvatar(),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: controller
                                          .currentUserAccounts
                                          .value!
                                          .user
                                          .value
                                          .avatar!
                                          .mediaURL
                                          .minURL
                                          .value,
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
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 18,
                          ),
                          hintText: CommonKeys.search.tr,
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
            child: Column(
              children: [
                Obx(
                  () => UserAccountsDrawerHeader(
                    margin: EdgeInsets.zero,
                    accountName: controller.currentUserAccounts.value!.user
                                .value.displayName ==
                            null
                        ? Shimmer.fromColors(
                            baseColor: Get.theme.disabledColor,
                            highlightColor: Get.theme.highlightColor,
                            child: const SizedBox(width: 20),
                          )
                        : Text(
                            controller.currentUserAccounts.value!.user.value
                                .displayName!,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    accountEmail: controller.currentUserAccounts.value!.user
                                .value.userMail ==
                            null
                        ? Shimmer.fromColors(
                            baseColor: Get.theme.disabledColor,
                            highlightColor: Get.theme.highlightColor,
                            child: const SizedBox(
                              width: 20,
                            ),
                          )
                        : Text(
                            controller.currentUserAccounts.value!.user.value
                                .userMail!,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: controller.currentUserAccounts.value!.user.value
                                  .avatar ==
                              null
                          ? Shimmer.fromColors(
                              baseColor: Get.theme.disabledColor,
                              highlightColor: Get.theme.highlightColor,
                              child: const CircleAvatar(),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: CachedNetworkImageProvider(
                                controller.currentUserAccounts.value!.user.value
                                    .avatar!.mediaURL.minURL.value,
                              ),
                            ),
                    ),
                    currentAccountPictureSize: const Size.square(75),
                    decoration: controller
                                .currentUserAccounts.value!.user.value.banner ==
                            null
                        ? null
                        : BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                controller.currentUserAccounts.value!.user.value
                                    .banner!.mediaURL.minURL.value,
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
                                    .value.role!.roleID ==
                                0,
                            child: ListTile(
                              leading: const Icon(Icons.group),
                              title: Text(DrawerKeys.drawerMeeting.tr),
                              onTap: () {},
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.article),
                          title: Text(DrawerKeys.drawerNews.tr),
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
                          title: Text(DrawerKeys.drawerMyGroups.tr),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermygroup.value) {
                                await controller.loadMyGroups(controller
                                    .currentUserAccounts.value!.user.value);
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
                              title: Text(DrawerKeys.drawerMyGroupscreate.tr),
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
                          title: Text(DrawerKeys.drawerMySchools.tr),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermyschool.value) {
                                await controller.loadMySchools(controller
                                    .currentUserAccounts.value!.user.value);
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
                              title: Text(DrawerKeys.drawerMySchoolsjoin.tr),
                              onTap: () {
                                // Get.to(const SchoolLoginPageView(), arguments: {
                                //   "currentUser": controller
                                //       .currentUserAccounts.value!.user,
                                // });
                                Get.toNamed("/school/login");
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
                          title: Text(DrawerKeys.drawerFood.tr),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermyfood.value) {
                                await controller.loadFoodStation(controller
                                    .currentUserAccounts.value!.user.value);
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
                          title: Text(DrawerKeys.drawerGames.tr),
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (!controller.drawermyfood.value) {
                                await controller.loadFoodStation(controller
                                    .currentUserAccounts.value!.user.value);
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
                          title: Text(DrawerKeys.drawerEvents.tr),
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
                          title: Text(DrawerKeys.drawerPolls.tr),
                          onTap: () {
                            Get.toNamed("/poll");
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.assignment_sharp),
                          title: Text(DrawerKeys.drawerInvite.tr),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => InvitePage(
                            //       currentUserAccounts:
                            //           controller.currentUserAccounts.value!,
                            //     ),
                            //   ),
                            // );
                            Get.toNamed("/invite");
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business_center),
                          title: Text(DrawerKeys.drawerJoinUs.tr),
                          onTap: () {
                            Get.toNamed("/applications");
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: Text(DrawerKeys.drawerSettings.tr),
                          onTap: () {
                            Get.toNamed("/settings", arguments: {
                              "currentUserAccounts":
                                  controller.currentUserAccounts.value,
                            });
                          },
                        ),
                        ListTile(
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.nightlight,
                            ),
                            onPressed: () {
                              Get.changeThemeMode(
                                Get.isDarkMode
                                    ? ThemeMode.light
                                    : ThemeMode.dark,
                              );
                              Get.back();
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
                  // scrollController: notificationScrollController,
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
                          backgroundColor: Get.theme.scaffoldBackgroundColor,
                          context: context,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                              heightFactor: 0.3,
                              child: Scaffold(
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
                                                ARMOYU
                                                    .appUsers[index]
                                                    .user
                                                    .value
                                                    .avatar!
                                                    .mediaURL
                                                    .minURL
                                                    .value,
                                              ),
                                            ),
                                            title: CustomText.costum1(
                                              ARMOYU.appUsers[index].user.value
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
                      child: Obx(
                        () => CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.transparent,
                          foregroundImage: CachedNetworkImageProvider(
                            findCurrentAccountController.currentUserAccounts
                                .value.user.value.avatar!.mediaURL.minURL.value,
                          ),
                        ),
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
