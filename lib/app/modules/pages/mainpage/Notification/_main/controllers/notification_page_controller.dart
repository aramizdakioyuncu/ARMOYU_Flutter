import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/notifications/notification_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/functions/functions_service.dart';
import 'package:armoyu_widgets/widgets/notification_bars/notification_bars_view.dart';
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

  Future<void> _loadMoreData() async {
    if (!notificationProccess.value) {
      await loadnoifications();
    }
  }

  Future<void> handleRefresh() async {
    page.value = 1;
    await loadnoifications();
  }

  Rxn<List<CustomMenusNotificationbars>> widgetNotifications = Rxn();

  Future<void> loadnoifications() async {
    if (notificationProccess.value) {
      return;
    }
    notificationProccess.value = true;

    FunctionService f = FunctionService(API.service);
    NotificationListResponse response =
        await f.getnotifications("", "", page.value);
    if (!response.result.status) {
      log(response.result.description);
      notificationProccess.value = false;
      firstProccess.value = false;

      return;
    }

    if (page.value == 1) {
      widgetNotifications.value = [];
      widgetNotifications.refresh();
    }

    if (response.response!.isEmpty) {
      notificationProccess.value = false;
      firstProccess.value = false;

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

      widgetNotifications.value ??= [];
      widgetNotifications.value!.add(
        CustomMenusNotificationbars(
          service: API.service,
          currentUserAccounts: currentUserAccounts,
          user: User(
            userID: element.bildirimGonderenID,
            displayName: Rx<String>(element.bildirimGonderenAdSoyad),
            avatar: Media(
              mediaID: element.bildirimGonderenID,
              mediaType: MediaType.image,
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
      widgetNotifications.refresh();
    }

    notificationProccess.value = false;
    firstProccess.value = false;
    page.value++;
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
            widgetNotifications.value!.length,
            (index) {
              return Column(
                children: [
                  widgetNotifications.value![index].notificationWidget(
                    Get.context!,
                    deleteFunction: () {
                      widgetNotifications.value!.removeAt(index);
                    },
                    profileFunction: () {},
                  ),
                  const SizedBox(height: 1)
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
