import 'dart:developer';
import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/functions/page_functions.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/group.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:armoyu_widgets/sources/notifications/bundle/notifications_bundle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPageController extends GetxController {
  final UserAccounts currentUserAccounts;
  NotificationPageController({
    required this.currentUserAccounts,
  });

  var firstProccess = true.obs;
  var notificationProccess = false.obs;
  var page = 1.obs;

  var scrollController = ScrollController().obs;

  late NotificationsBundle notifications;
  late Widget notificationsdetail;

  @override
  void onInit() {
    super.onInit();

    final mainController = Get.find<MainPageController>(
      tag: currentUserAccounts.user.value.userID.toString(),
    );

    scrollController.value = mainController.notificationScrollController;

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels >=
          scrollController.value.position.maxScrollExtent * 0.5) {
        notifications.loadMore();
      }
    });

    notificationsdetail = API.widgets.notifications.notificationdetail(
      onTap: (category) {
        if (category == "friend-request") {
          Get.toNamed("/notifications/friend-request");
          return;
        }

        if (category == "group-request") {
          Get.toNamed("/notifications/group-request");
          return;
        }
      },
    );

    notifications = API.widgets.notifications.notifications(
      cachedNotificationList: API
          .widgets.accountController.currentUserAccounts.value.notificationList,
      onNotificationUpdated: (updatedNotifications) {
        API.widgets.accountController.currentUserAccounts.value
            .notificationList = updatedNotifications;
        log("onNotificationsUpdated: ${updatedNotifications.length}   AccountItems: ${API.widgets.accountController.currentUserAccounts.value.notificationList!.length}");
      },
      profileFunction: (userID, username) {
        PageFunctions().pushProfilePage(
          Get.context!,
          User(
            userID: userID,
            userName: Rx(username),
          ),
        );
      },
      onTap: (category, categorydetail, categorydetailID) {
        if (categorydetail == "post") {
          Get.toNamed("/social/detail", arguments: {
            "postID": categorydetailID,
          });
        } else if (categorydetail == "postyorum") {
          Get.toNamed("/social/detail", arguments: {
            "commentID": categorydetailID,
          });
        } else if (category == "gruplar") {
          Get.toNamed("/group/detail", arguments: {
            'user': currentUserAccounts.user,
            'group': Group(groupID: categorydetailID)
          });
        } else if (category == "arkadaslik") {
          if (categorydetail == "kabul") {
            // PageFunctions().pushProfilePage(
            //   Get.context!,
            //   User(
            //     userID: categorydetailID,
            //   ),
            // );
          }
        }
      },
    );
  }
}
