import 'dart:developer';
import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/sources/notifications/bundle/notifications_bundle.dart';
import 'package:armoyu_widgets/widgets/notification_bars/notification_bars_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendrequestController extends GetxController {
  var pageproccess = false.obs;
  var page = 1.obs;
  var firstFetchProcces = true.obs;
  var widgetNotifications = <Notifications>[].obs;

  var scrollController = ScrollController().obs;

  late NotificationsBundle notifications;

  @override
  void onInit() {
    super.onInit();

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels >=
          scrollController.value.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        notifications.loadMore();
      }
    });

    notifications = API.widgets.notifications.notifications(
      onTap: (category, categorydetail, categorydetailID) {},
      category: "arkadaslik",
      categorydetail: "istek",
      profileFunction: (userID, username) {
        log("profileFunction userID: $userID, username: $username");
      },
    );
  }
}
