import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/notification_bars.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/notifications/notification_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrouprequestController extends GetxController {
  var postpageproccess = false.obs;
  var postpage = 1.obs;
  var firstFetchProcces = true.obs;
  var widgetNotifications = <CustomMenusNotificationbars>[].obs;

  var scrollController = ScrollController().obs;

  var currentUserAccounts =
      Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));

  @override
  void onInit() {
    super.onInit();

    //***//
    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    //***//

    if (firstFetchProcces.value) {
      loadnoifications(postpage.value);
    }

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels >=
          scrollController.value.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        loadMoreData();
      }
    });
  }

  Future<void> loadMoreData() async {
    if (!postpageproccess.value) {
      await loadnoifications(postpage.value);
    }
  }

  Future<void> handleRefresh() async {
    // setState(() {
    postpage.value = 1;
    loadnoifications(postpage.value);
    // });
  }

  Future<void> loadnoifications(int page) async {
    if (postpageproccess.value) {
      return;
    }

    // setState(() {
    postpageproccess.value = true;
    // });
    if (page == 1) {
      widgetNotifications.clear();
    }
    FunctionService f = FunctionService();
    NotificationListResponse response =
        await f.getnotifications("gruplar", "davet", page);

    if (!response.result.status) {
      log(response.result.description);
      firstFetchProcces.value = false;
      postpageproccess.value = false;
      return;
    }

    if (response.response!.isEmpty) {
      firstFetchProcces.value = false;
      postpageproccess.value = false;
      return;
    }

    var noticiationbuttons = false.obs;

    for (APINotificationList element in response.response!) {
      noticiationbuttons.value = false;

      if (element.bildirimAmac.toString() == "arkadaslik") {
        if (element.bildirimKategori.toString() == "istek") {
          noticiationbuttons.value = true;
        }
      } else if (element.bildirimAmac.toString() == "gruplar") {
        if (element.bildirimKategori.toString() == "davet") {
          noticiationbuttons.value = true;
        }
      }

      widgetNotifications.add(
        CustomMenusNotificationbars(
          currentUserAccounts: currentUserAccounts.value,
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
          enableButtons: noticiationbuttons.value,
          text: element.bildirimIcerik,
        ),
      );
    }

    firstFetchProcces.value = false;
    postpageproccess.value = false;

    postpage++;
  }
}
