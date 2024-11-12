import 'dart:developer';
import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Profile/profile_page/controllers/profile_controller.dart';
import 'package:ARMOYU/app/modules/utils/newphotoviewer.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/appbar_widget.dart';
import 'package:ARMOYU/app/widgets/bottomnavigationbar.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  final ScrollController? profileScrollController;
  final UserAccounts? currentUserAccounts;

  const ProfileView({
    super.key,
    this.currentUserAccounts,
    this.profileScrollController,
  });

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
    if (widget.currentUserAccounts != null) {
      currentUserAccount = widget.currentUserAccounts!;
    } else {
      currentUserAccount =
          findCurrentAccountController.currentUserAccounts.value;
    }

    //Mevcut Oturum Kullanıcısı Kontrolü Çok Önemli

    final currentAccountController = Get.find<PagesController>(
      tag: currentUserAccount.user.value.userID.toString(),
    );
    log("***profile**${currentAccountController.currentUserAccount.user.value.displayName}");

    /////
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

    //Create dememizin sebebi sürekli oluştursun put dersen bir kere oluştur varsa daha oluşturmaz
    //bir kullanıcıyı birden fazla ziyaret edebilmemize imkan sağlıyor

    final controller = Get.put(
      ProfileController(
        // currentUserAccounts: currentAccountController.currentUserAccounts.obs,
        scrollController: widget.profileScrollController,
      ),
      tag: uniqueTag,
    );

    return Scaffold(
      // backgroundColor: ARMOYU.backgroundcolor,
      appBar: controller.ismyProfile.value ? AppbarWidget.custom() : null,

      body: NestedScrollView(
        controller: controller.profileScrollController.value,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: !controller.ismyProfile.value ? true : false,
              // backgroundColor: ARMOYU.appbarColor,
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
                          currentUser: currentAccountController
                              .currentUserAccount.user.value,
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
                        visible:
                            controller.userProfile.value.registerDate != null,
                        child: controller.getRegisterDateWidget(),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Visibility(
                          visible: controller.userProfile.value.burc != null,
                          child: controller.getBurcWidget()),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Visibility(
                          visible: controller.userProfile.value.country != null,
                          child: controller.getCountryAndProvinceWidget()),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Visibility(
                        visible: controller.userProfile.value.job != null,
                        child: controller.getJobWidget(),
                      ),
                    ),
                    Obx(
                      () => controller.getFriendListWidget(context),
                    ),
                    Row(
                      children: [
                        Obx(
                          () => controller.buildFriendButton(context),
                        ),
                        Obx(
                          () => controller.buildFriendRequestButton(context),
                        ),
                        Obx(
                          () => controller.buildMessageButton(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => Visibility(
                        visible: controller.userProfile.value.aboutme != null,
                        child: controller.buildAboutMeSection(context),
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
          physics: const ClampingScrollPhysics(),
          controller: controller.tabController,
          children: [
            Obx(
              () => controller.buildPostList(),
            ),
            Obx(
              () => controller.buildGallery(),
            ),
            Obx(
              () => controller.buildTaggedPosts(),
            ),
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
        indicatorColor: ARMOYU.color,
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
