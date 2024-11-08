import 'dart:developer';

import 'package:ARMOYU/app/modules/pages/mainpage/Notification/friend_request_page/controllers/friendrequest_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
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
        title: const Text("Arkadaşlık İstekleri"),
        actions: [
          IconButton(
            onPressed: () async {
              controller.page.value = 1;
              await controller.loadnoifications();
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
            onRefresh: controller.handleRefresh,
          ),
          Obx(
            () => controller.widgetNotifications.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: !controller.firstFetchProcces.value &&
                              !controller.pageproccess.value
                          ? const Text("Arkadaşlık istek kutusu boş")
                          : const CupertinoActivityIndicator(),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: controller.widgetNotifications.length,
                      (context, index) {
                        return Column(
                          children: [
                            controller.widgetNotifications[index],
                            const SizedBox(height: 1)
                          ],
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
