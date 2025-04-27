import 'dart:developer';

import 'package:armoyu/app/modules/pages/mainpage/Notification/group_request_page/controllers/grouprequest_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrouprequestView extends StatelessWidget {
  const GrouprequestView({super.key});

  @override
  Widget build(BuildContext context) {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    final controller = Get.put(
      GrouprequestController(),
      tag: findCurrentAccountController
          .currentUserAccounts.value.user.value.userID
          .toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(NotificationKeys.groupRequests.tr),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.notifications.refresh();
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
          SliverToBoxAdapter(
            child: controller.notifications.widget.value!,
          ),
        ],
      ),
    );
  }
}
