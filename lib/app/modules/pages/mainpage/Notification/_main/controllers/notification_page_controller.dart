import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/notification_bars.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/notifications/notification_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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

  @override
  void onInit() {
    super.onInit();

    final mainController = Get.find<MainPageController>(
      tag: currentUserAccounts.user.value.userID.toString(),
    );

    scrollController.value = mainController.notificationScrollController;
    loadnoifications();

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels >=
          scrollController.value.position.maxScrollExtent * 0.5) {
        _loadMoreData();
      }
    });
  }

  void setstatefunction() {
    // if (mounted) {
    //   setState(() {});
    // }
  }

  Future<void> _loadMoreData() async {
    if (!notificationProccess.value) {
      await loadnoifications();
    }
  }

  Future<void> handleRefresh() async {
    page.value = 1;
    await loadnoifications();
  }

  List<CustomMenusNotificationbars> widgetNotifications = [];

  Future<void> loadnoifications() async {
    if (notificationProccess.value) {
      return;
    }
    notificationProccess.value = true;

    FunctionService f =
        FunctionService(currentUser: currentUserAccounts.user.value);
    NotificationListResponse response =
        await f.getnotifications("", "", page.value);
    if (!response.result.status) {
      log(response.result.description);
      notificationProccess.value = false;
      firstProccess.value = false;

      setstatefunction();
      return;
    }

    if (page.value == 1) {
      widgetNotifications.clear();
      setstatefunction();
    }

    if (response.response!.isEmpty) {
      notificationProccess.value = false;
      firstProccess.value = false;
      setstatefunction();

      return;
    }

    bool noticiationbuttons = false;

    for (APINotificationList element in response.response!) {
      noticiationbuttons = false;

      if (element.bildirimAmac.toString() == "arkadaslik") {
        if (element.bildirimKategori.toString() == "istek") {
          noticiationbuttons = true;
        }
      } else if (element.bildirimAmac.toString() == "gruplar") {
        if (element.bildirimKategori.toString() == "davet") {
          noticiationbuttons = true;
        }
      }
      widgetNotifications.add(
        CustomMenusNotificationbars(
          currentUserAccounts: currentUserAccounts,
          user: User(
            userID: element.bildirimGonderenID,
            displayName: Rx<String>(element.bildirimGonderenAdSoyad),
            avatar: Media(
              mediaID: element.bildirimGonderenID,
              mediaURL: MediaURL(
                bigURL: Rx<String>(element.bildirimGonderenAvatar),
                normalURL: Rx<String>(element.bildirimGonderenAvatar),
                minURL: Rx<String>(element.bildirimGonderenAvatar),
              ),
            ),
          ),
          category: element.bildirimAmac,
          categorydetail: element.bildirimKategori,
          categorydetailID: element.bildirimKategoriDetay,
          date: element.bildirimZaman,
          enableButtons: noticiationbuttons,
          text: element.bildirimIcerik,
        ),
      );
      setstatefunction();
    }

    notificationProccess.value = false;
    firstProccess.value = false;
    page.value++;
    setstatefunction();
  }

  Widget notificationlistwidget() {
    if (firstProccess.value) {
      return const SliverFillRemaining(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            leading: const Icon(
              Icons.person_add_rounded,
            ),
            title: CustomText.costum1(NotificationKeys.friendRequests.tr),
            subtitle:
                CustomText.costum1(NotificationKeys.reviewFriendRequests.tr),
            trailing: Badge(
              isLabelVisible: currentUserAccounts.friendRequestCount.value == 0
                  ? false
                  : true,
              label: Text(currentUserAccounts.friendRequestCount.toString()),
              backgroundColor: Colors.red,
              textColor: Colors.white,
              child: Icon(
                currentUserAccounts.friendRequestCount.value == 0
                    ? Icons.notifications
                    : Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Get.toNamed("/notifications/friend-request");
            },
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            leading: const Icon(
              Icons.groups_2,
            ),
            title: CustomText.costum1(NotificationKeys.groupRequests.tr),
            subtitle: CustomText.costum1(
              NotificationKeys.reviewGroupRequests.tr,
            ),
            trailing: Badge(
              isLabelVisible: currentUserAccounts.groupInviteCount.value == 0
                  ? false
                  : true,
              label: Text(currentUserAccounts.groupInviteCount.toString()),
              backgroundColor: Colors.red,
              textColor: Colors.white,
              child: Icon(
                currentUserAccounts.groupInviteCount.value == 0
                    ? Icons.notifications
                    : Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Get.toNamed("/notifications/group-request");
            },
          ),
          ...List.generate(
            widgetNotifications.length,
            (index) {
              return Column(
                children: [
                  widgetNotifications[index],
                  const SizedBox(height: 1)
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
