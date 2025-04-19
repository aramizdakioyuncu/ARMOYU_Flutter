import 'dart:developer';

import 'package:armoyu/app/modules/pages/mainpage/socail_page/controllers/socail_page_controller.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:armoyu/app/widgets/bottomnavigationbar.dart';
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
          SliverToBoxAdapter(
            child: controller.widgetstory.value,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 1)),
          SliverToBoxAdapter(
            child: controller.widgetposts.widget.value,
          ),
          const SliverToBoxAdapter(
            child: Visibility(
              visible: true,
              child: SizedBox(
                height: 100,
                child: CupertinoActivityIndicator(),
              ),
            ),
          ),
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
