import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/notification_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendrequestController extends GetxController {
  var pageproccess = false.obs;
  var page = 1.obs;
  var firstFetchProcces = true.obs;
  var widgetNotifications = <CustomMenusNotificationbars>[].obs;

  var scrollController = ScrollController().obs;

  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));

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

    FunctionService f =
        FunctionService(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response =
        await f.getnotifications("arkadaslik", "istek", page.value);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      pageproccess.value = false;
      firstFetchProcces.value = false;

      return;
    }
    if (page.value == 1) {
      widgetNotifications.clear();
    }
    if (response["icerik"].length == 0) {
      pageproccess.value = false;
      firstFetchProcces.value = false;

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
          currentUserAccounts: currentUserAccounts.value,
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

    firstFetchProcces.value = false;
    pageproccess.value = false;
    page++;
  }
}
