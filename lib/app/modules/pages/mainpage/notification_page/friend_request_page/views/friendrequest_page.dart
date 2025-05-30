import 'dart:developer';

import 'package:armoyu/app/modules/pages/mainpage/notification_page/friend_request_page/controllers/friendrequest_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendRequestView extends StatelessWidget {
  const FriendRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    final controller = Get.put(
      FriendrequestController(),
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(NotificationKeys.friendRequests.tr),
        actions: [
          IconButton(
            onPressed: () async {
              controller.page.value = 1;
              await controller.notifications.loadMore();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: controller.scrollController.value,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: controller.notifications.refresh,
          ),
          Obx(
            () => controller.widgetNotifications.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: !controller.firstFetchProcces.value &&
                              !controller.pageproccess.value
                          ? Text(CommonKeys.empty.tr)
                          : const CupertinoActivityIndicator(),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: controller.notifications.widget.value!,
                  ),
          ),
        ],
      ),
    );
  }
}
