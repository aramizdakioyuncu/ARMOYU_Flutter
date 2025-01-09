import 'dart:developer';

import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/widgets/notification_bars/notification_bars_view.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/notifications/notification_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendrequestController extends GetxController {
  var pageproccess = false.obs;
  var page = 1.obs;
  var firstFetchProcces = true.obs;
  var widgetNotifications = <CustomMenusNotificationbars>[].obs;

  var scrollController = ScrollController().obs;

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    //***//
    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    //***//

    if (firstFetchProcces.value) {
      loadnoifications();
    }

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels >=
          scrollController.value.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });
  }

  void setstatefunction() {
    setstatefunction();
  }

  Future<void> _loadMoreData() async {
    if (!pageproccess.value) {
      await loadnoifications();
    }
  }

  Future<void> handleRefresh() async {
    page.value = 1;
    loadnoifications();
  }

  Future<void> loadnoifications() async {
    if (pageproccess.value) {
      return;
    }
    pageproccess.value = true;

    FunctionService f = FunctionService();
    NotificationListResponse response =
        await f.getnotifications("arkadaslik", "istek", page.value);

    if (!response.result.status) {
      log(response.result.description);
      pageproccess.value = false;
      firstFetchProcces.value = false;

      return;
    }
    if (page.value == 1) {
      widgetNotifications.clear();
    }
    if (response.response!.isEmpty) {
      pageproccess.value = false;
      firstFetchProcces.value = false;

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
          enableButtons: noticiationbuttons,
          text: element.bildirimIcerik,
        ),
      );

      setstatefunction();
    }

    firstFetchProcces.value = false;
    pageproccess.value = false;
    page++;
  }
}
