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
              controller.postpage.value = 1;
              await controller.loadnoifications(controller.postpage.value);
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.handleRefresh,
        child: Obx(
          () => controller.widgetNotifications.isEmpty
              ? Center(
                  child: !controller.firstFetchProcces.value &&
                          !controller.postpageproccess.value
                      ? Text(CommonKeys.empty.tr)
                      : const CupertinoActivityIndicator(),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller.scrollController.value,
                  itemCount: controller.widgetNotifications.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        controller.widgetNotifications[index]
                            .notificationWidget(
                          context,
                          deleteFunction: () {
                            controller.widgetNotifications.removeAt(index);
                          },
                          profileFunction: () {
                            // Profile sayfasına gitme işlemi
                          },
                        ),
                        const SizedBox(height: 1)
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
