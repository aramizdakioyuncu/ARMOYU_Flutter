import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/modules/pages/mainpage/mediaplayer_page/views/mediaplayer_view.dart';
import 'package:armoyu/app/modules/pages/mainpage/notification_page/_main/views/notification_page.dart';
import 'package:armoyu/app/modules/pages/mainpage/profile_page/profile_page/views/profile_view.dart';
import 'package:armoyu/app/modules/pages/mainpage/search_page/views/search_view.dart';
import 'package:armoyu/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:armoyu/app/modules/utils/camera/controllers/cam_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/functions/functions.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:armoyu/app/Services/Utility/barcode.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    //
    //
    final camcontroller = Get.put(CamController());
    //
    //

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
          key: controller.scaffoldKey,
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
                                .displayName!.value,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                    accountEmail: controller.currentUserAccounts.value!.user
                                .value.detailInfo!.value!.email.value ==
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
                                .detailInfo!.value!.email.value!,
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const EventlistPage(),
                            //   ),
                            // );

                            Get.toNamed("/event/list");
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
                service: API.service,
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
                      if (camcontroller.cameraController.value == null) {
                        camcontroller.startcamservice();
                      }
                    } else {
                      controller.isBottomNavbarVisible.value = true;
                      camcontroller.stopcamservice();
                    }
                  },
                  children: controller.mainsocialpages,
                ),
              ),
              Obx(
                () => SearchView(
                  currentUserAccounts: controller.currentUserAccounts.value!,
                  appbar: true,
                  scrollController: searchScrollController,
                ),
              ),
              if (MediaQuery.of(Get.context!).size.width >= 450)
                MediaplayerView(),
              Obx(
                () => NotificationPage(
                  currentUserAccounts: controller.currentUserAccounts.value!,
                  // scrollController: notificationScrollController,
                ),
              ),
              const ProfileView(ismyprofile: true),
            ],
          ),
        ),
      ),
    );
  }
}
