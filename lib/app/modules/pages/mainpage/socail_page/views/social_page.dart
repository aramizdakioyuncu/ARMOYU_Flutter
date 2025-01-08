import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/socail_page/controllers/socail_page_controller.dart';
import 'package:ARMOYU/app/widgets/appbar_widget.dart';
import 'package:ARMOYU/app/widgets/bottomnavigationbar.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialPage extends StatefulWidget {
  final ScrollController homepageScrollController;

  const SocialPage({
    super.key,
    required this.homepageScrollController,
  });

  @override
  State<StatefulWidget> createState() => _SocialPage();
}

class _SocialPage extends State<SocialPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    log("***Social**${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

    final controller = Get.put(
      SocailPageController(scrollController: widget.homepageScrollController),
      tag: "socail-$uniqueTag",
    );

    return Scaffold(
      appBar: AppbarWidget.custom(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.scrollController,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller.handleRefresh();
            },
          ),
          // Obx(
          //   () => SliverToBoxAdapter(child: controller.widgetStories.value),
          // ),

          SliverToBoxAdapter(
            child: API.widgets.social.widgetStorycircle(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 1)),
          // Obx(
          //   () => SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       childCount: controller.widgetPosts.length,
          //       (BuildContext context, int index) {
          //         return Obx(() => controller.widgetPosts[index]);
          //       },
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: API.widgets.social.posts(
              context: context,
              scrollController: controller.scrollController,
              shrinkWrap: true,
              profileFunction: (userID, username) {
                log('$userID $username');
                PageFunctions().pushProfilePage(
                  context,
                  User(
                    userName: Rx(username),
                  ),
                );
              },
            ),
          ),
          // Obx(
          //   () => SliverToBoxAdapter(
          //     child: Visibility(
          //       visible: controller.fetchPostStatus.value,
          //       child: const SizedBox(
          //         height: 100,
          //         child: CupertinoActivityIndicator(),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag:
            "socailshare${findCurrentAccountController.currentUserAccounts.value.user.value.userID}",
        onPressed: () {
          Get.toNamed("/social/share");
        },
        child: const Icon(Icons.post_add),
      ),
      bottomNavigationBar: BottomnavigationBar.custom1(),
    );
  }
}
