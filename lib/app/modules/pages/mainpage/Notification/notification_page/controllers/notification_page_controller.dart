import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Notification/friend_request_page/views/friendrequest_page.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/Notification/group_request_page/views/grouprequest_page.dart';
import 'package:ARMOYU/app/widgets/notification_bars.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPageController extends GetxController {
  final UserAccounts currentUserAccounts;
  final ScrollController scrollController;
  NotificationPageController({
    required this.currentUserAccounts,
    required this.scrollController,
  });

  var firstProccess = true.obs;
  var notificationProccess = false.obs;
  var _page = 1.obs;

  late final ScrollController _scrollController;

  @override
  void onInit() {
    super.onInit();

    _scrollController = scrollController;
    loadnoifications();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
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
    _page.value = 1;
    await loadnoifications();
  }

  List<CustomMenusNotificationbars> widgetNotifications = [];

  Future<void> loadnoifications() async {
    if (notificationProccess.value) {
      return;
    }
    notificationProccess.value = true;
    // if (mounted) {
    //   setState(() {});
    // }
    FunctionService f = FunctionService(currentUser: currentUserAccounts.user);
    Map<String, dynamic> response =
        await f.getnotifications("", "", _page.value);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      notificationProccess.value = false;
      firstProccess.value = false;

      setstatefunction();
      return;
    }

    if (_page.value == 1) {
      widgetNotifications.clear();
      setstatefunction();
    }

    if (response["icerik"].length == 0) {
      notificationProccess.value = false;
      firstProccess.value = false;
      setstatefunction();

      return;
    }

    bool noticiationbuttons = false;
    for (int i = 0; i < response["icerik"].length; i++) {
      noticiationbuttons = false;

      if (response["icerik"][i]["bildirimamac"].toString() == "arkadaslik") {
        if (response["icerik"][i]["bildirimkategori"].toString() == "istek") {
          noticiationbuttons = true;
        }
      } else if (response["icerik"][i]["bildirimamac"].toString() ==
          "gruplar") {
        if (response["icerik"][i]["bildirimkategori"].toString() == "davet") {
          noticiationbuttons = true;
        }
      }
      widgetNotifications.add(
        CustomMenusNotificationbars(
          currentUserAccounts: currentUserAccounts,
          user: User(
            userID: response["icerik"][i]["bildirimgonderenID"],
            displayName: response["icerik"][i]["bildirimgonderenadsoyad"],
            avatar: Media(
              mediaID: response["icerik"][i]["bildirimgonderenID"],
              mediaURL: MediaURL(
                bigURL: response["icerik"][i]["bildirimgonderenavatar"],
                normalURL: response["icerik"][i]["bildirimgonderenavatar"],
                minURL: response["icerik"][i]["bildirimgonderenavatar"],
              ),
            ),
          ),
          category: response["icerik"][i]["bildirimamac"],
          categorydetail: response["icerik"][i]["bildirimkategori"],
          categorydetailID: response["icerik"][i]["bildirimkategoridetay"],
          date: response["icerik"][i]["bildirimzaman"],
          enableButtons: noticiationbuttons,
          text: response["icerik"][i]["bildirimicerik"],
        ),
      );
      setstatefunction();
    }

    notificationProccess.value = false;
    firstProccess.value = false;
    _page++;
    setstatefunction();
  }

  Widget notificationlistwidget() {
    if (firstProccess.value) {
      return CustomScrollView(
        controller: scrollController,
        slivers: const [
          SliverFillRemaining(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        ],
      );
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            leading: Icon(
              Icons.person_add_rounded,
              color: ARMOYU.color,
            ),
            // tileColor: ARMOYU.appbarColor,
            title: CustomText.costum1("Arkadaşlık İstekleri"),
            subtitle: CustomText.costum1("Arkadaşlık isteklerini gözden geçir"),
            trailing: Badge(
              isLabelVisible:
                  currentUserAccounts.friendRequestCount == 0 ? false : true,
              label: Text(currentUserAccounts.friendRequestCount.toString()),
              backgroundColor: Colors.red,
              textColor: Colors.white,
              child: Icon(
                currentUserAccounts.friendRequestCount == 0
                    ? Icons.notifications
                    : Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => NotificationFriendRequestPage(
                    currentUserAccounts: currentUserAccounts,
                  ),
                ),
              );
            },
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            leading: Icon(
              Icons.groups_2,
              color: ARMOYU.color,
            ),
            // tileColor: ARMOYU.appbarColor,
            title: CustomText.costum1("Grup İstekleri"),
            subtitle: CustomText.costum1(
              "Grup isteklerini gözden geçir",
            ),
            trailing: Badge(
              isLabelVisible:
                  currentUserAccounts.groupInviteCount == 0 ? false : true,
              label: Text(currentUserAccounts.groupInviteCount.toString()),
              backgroundColor: Colors.red,
              textColor: Colors.white,
              child: Icon(
                currentUserAccounts.groupInviteCount == 0
                    ? Icons.notifications
                    : Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => NotificationGroupRequestPage(
                    currentUserAccounts: currentUserAccounts,
                  ),
                ),
              );
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
