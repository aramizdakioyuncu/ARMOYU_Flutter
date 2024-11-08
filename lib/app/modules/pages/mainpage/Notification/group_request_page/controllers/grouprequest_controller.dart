import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions_service.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/notification_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrouprequestController extends GetxController {
  var postpageproccess = false.obs;
  var postpage = 1.obs;
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
    FunctionService f =
        FunctionService(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response =
        await f.getnotifications("gruplar", "davet", page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      firstFetchProcces.value = false;
      postpageproccess.value = false;
      return;
    }

    if (response["icerik"].length == 0) {
      firstFetchProcces.value = false;
      postpageproccess.value = false;
      return;
    }

    var noticiationbuttons = false.obs;
    for (int i = 0; i < response["icerik"].length; i++) {
      noticiationbuttons.value = false;

      if (response["icerik"][i]["bildirimamac"].toString() == "arkadaslik") {
        if (response["icerik"][i]["bildirimkategori"].toString() == "istek") {
          noticiationbuttons.value = true;
        }
      } else if (response["icerik"][i]["bildirimamac"].toString() ==
          "gruplar") {
        if (response["icerik"][i]["bildirimkategori"].toString() == "davet") {
          noticiationbuttons.value = true;
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
          enableButtons: noticiationbuttons.value,
          text: response["icerik"][i]["bildirimicerik"],
        ),
      );
    }

    firstFetchProcces.value = false;
    postpageproccess.value = false;

    postpage++;
  }
}
