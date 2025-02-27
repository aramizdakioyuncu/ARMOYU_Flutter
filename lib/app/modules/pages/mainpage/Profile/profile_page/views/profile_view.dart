import 'dart:developer';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/controllers/profile_controller.dart';
import 'package:ARMOYU/app/modules/utils/newphotoviewer.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';

import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/appbar_widget.dart';
import 'package:ARMOYU/app/widgets/bottomnavigationbar.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  final bool? ismyprofile;
  const ProfileView({super.key, this.ismyprofile});

  @override
  State<ProfileView> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin<ProfileView>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    //Mevcut Oturum Kullanıcısı Kontrolü Çok Önemli
    late UserAccounts currentUserAccount;
    currentUserAccount = findCurrentAccountController.currentUserAccounts.value;
    //Mevcut Oturum Kullanıcısı Kontrolü Çok Önemli

    final currentAccountController = Get.find<PagesController>(
      tag: currentUserAccount.user.value.userID.toString(),
    );
    log("***profile**${currentAccountController.currentUserAccount.user.value.displayName}");

    /////
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

    final controller = Get.put(
      ProfileController(),
      tag: widget.ismyprofile == true ? "myprofile" : uniqueTag,
    );

    return Scaffold(
      appBar: controller.ismyProfile.value ? AppbarWidget.custom() : null,
      body: NestedScrollView(
        controller: controller.profileScrollController.value,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: !controller.ismyProfile.value ? true : false,
              expandedHeight: ARMOYU.screenHeight * 0.25,
              leading: Obx(
                () => controller.buildLeadingWidget(context),
              ),
              title: Obx(
                () => controller.buildTitleWidget(),
              ),
              actions: <Widget>[
                Obx(
                  () => controller.userProfile.value.userID == null
                      ? const SizedBox()
                      : IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            controller.showProfileActions(context);
                          },
                        ),
                ),
                const SizedBox(width: 10),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: GestureDetector(
                  onTap: () {
                    if (controller.userProfile.value.banner == null) {
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MediaViewer(
                          currentUserID: currentAccountController
                              .currentUserAccount.user.value.userID!,
                          media: [controller.userProfile.value.banner!],
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    if (!controller.ismyProfile.value) {
                      return;
                    }
                    showModalBottomSheet<void>(
                      backgroundColor: Get.theme.scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Wrap(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[900],
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      width: ARMOYU.screenWidth / 4,
                                      height: 5,
                                    ),
                                  ),
                                  Visibility(
                                    visible: controller.ismyProfile.value,
                                    child: InkWell(
                                      onTap: () async {
                                        await controller.changebanner();
                                      },
                                      child: const ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Arkaplan değiştir."),
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Visibility(
                                    visible: controller.ismyProfile.value,
                                    child: InkWell(
                                      onTap: () async =>
                                          await controller.defaultbanner(),
                                      child: const ListTile(
                                        textColor: Colors.red,
                                        leading: Icon(
                                          Icons.person_off_outlined,
                                          color: Colors.red,
                                        ),
                                        title: Text("Varsayılana dönder."),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Obx(
                    () => controller.buildBannerWidget(context),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Obx(
                                () => controller.buildProfileAvatar(context),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Obx(
                              () => Column(
                                children: [
                                  Row(
                                    children: [
                                      const Spacer(),
                                      controller.getPostsCountWidget(),
                                      const Spacer(),
                                      controller.getFriendsCountWidget(context),
                                      const Spacer(),
                                      controller.getAwardsCountWidget(),
                                      const Spacer(),
                                      controller.getFavTeamWidget(context),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.userProfile.value.detailInfo == null
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.lock,
                                  size: 40,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Obx(() => controller.getDisplayNameWidget()),
                                Row(
                                  children: [
                                    Obx(() => controller.getUserNameWidget()),
                                    const SizedBox(width: 5),
                                    Obx(() => controller.getUserRoleWidget()),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Obx(
                                  () => Visibility(
                                    visible: controller
                                            .userProfile.value.registerDate !=
                                        null,
                                    child: controller.getRegisterDateWidget(),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Obx(
                                  () => controller.getBurcWidget(),
                                ),
                                const SizedBox(height: 5),
                                Obx(
                                  () =>
                                      controller.getCountryAndProvinceWidget(),
                                ),
                                const SizedBox(height: 5),
                                Obx(
                                  () => controller.getJobWidget(),
                                ),
                                Obx(
                                  () => controller.getFriendListWidget(context),
                                ),
                                Row(
                                  children: [
                                    Obx(
                                      () =>
                                          controller.buildFriendButton(context),
                                    ),
                                    Obx(
                                      () => controller
                                          .buildFriendRequestButton(context),
                                    ),
                                    Obx(
                                      () => controller
                                          .buildMessageButton(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Obx(
                                  () => controller.buildAboutMeSection(context),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: Profileusersharedmedias(controller.tabController),
            ),
          ];
        },
        body: TabBarView(
          controller: controller.tabController,
          children: [
            Obx(
              () => controller.widget.value ?? Container(),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // CupertinoSliverRefreshControl(
                //   onRefresh: () async => await controller.handleRefresh(
                //     myProfileRefresh: true,
                //   ),
                // ),
                Obx(
                  () => SliverToBoxAdapter(
                    child: Center(
                      child: controller.widget2.value ?? Container(),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() => controller.widget3.value!),
          ],
        ),
      ),
      bottomNavigationBar:
          controller.ismyProfile.value ? BottomnavigationBar.custom1() : null,
    );
  }
}

class Profileusersharedmedias extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  Profileusersharedmedias(this.tabController);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      alignment: Alignment.center,
      color: Get.theme.scaffoldBackgroundColor,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        indicatorColor: Get.theme.hintColor,
        tabs: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.costum1(ProfileKeys.profilePosts.tr, size: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText.costum1(ProfileKeys.profileMedia.tr, size: 15.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                CustomText.costum1(ProfileKeys.profileMentions.tr, size: 15.0),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
