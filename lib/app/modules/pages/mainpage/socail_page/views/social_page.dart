import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/Social/share_post_page/views/postshare_page.dart';
import 'package:ARMOYU/app/modules/pages/_main/controllers/pages_controller.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/socail_page/controllers/socail_page_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final ScrollController homepageScrollController;

  const SocialPage({
    super.key,
    required this.currentUserAccounts,
    required this.homepageScrollController,
  });

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with AutomaticKeepAliveClientMixin<SocialPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final currentAccountController = Get.find<PagesController>(
      tag: widget.currentUserAccounts.user.userID.toString(),
    );

    log("***Social**${currentAccountController.currentUserAccounts.user.displayName}");

    final controller = Get.put(
      SocailPageController(
        currentUserAccounts: currentAccountController.currentUserAccounts,
        scrollController: widget.homepageScrollController,
      ),
      tag: widget.currentUserAccounts.user.userID.toString(),
    );

    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.scrollController,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller.handleRefresh();
            },
          ),
          Obx(
            () => SliverToBoxAdapter(child: controller.widgetStories.value),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 1)),
          Obx(
            () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return controller.widgetPosts[index];
                },
                childCount: controller.widgetPosts.length,
              ),
            ),
          ),
          Obx(
            () => SliverToBoxAdapter(
              child: Visibility(
                visible: controller.fetchPostStatus.value,
                child: Container(
                  height: 100,
                  color: ARMOYU.appbarColor,
                  child: const CupertinoActivityIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "socailshare${widget.currentUserAccounts.user.userID}",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostSharePage(
                currentUser: widget.currentUserAccounts.user,
              ),
            ),
          );
        },
        backgroundColor: ARMOYU.buttonColor,
        child: const Icon(
          Icons.post_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
