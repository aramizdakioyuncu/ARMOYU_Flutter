import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/news.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/news/news_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListNewsController extends GetxController {
  late var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    user.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    if (newsList.isEmpty) {
      getnewslist();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getnewslist();
      }
    });
  }

  var newspage = 1.obs;
  var eventlistProcces = false.obs;
  var newsList = <News>[].obs;

  var scrollController = ScrollController();
  var refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Widget widgetnews(context, index) {
    return newsList[index].newsListWidget(
      Get.context,
      currentUser: user.value!,
    );
  }

  Future<void> getnewslist() async {
    if (eventlistProcces.value) {
      return;
    }

    eventlistProcces.value = true;

    NewsListResponse response =
        await API.service.newsServices.fetch(page: newspage.value);
    if (!response.result.status) {
      log(response.result.description);
      eventlistProcces.value = false;
      //Tekrar çekmeyi dene
      getnewslist();
      return;
    }

    if (newspage.value == 1) {
      newsList.clear();
    }

    if (response.response!.news.isEmpty) {
      eventlistProcces.value = true;
      log("Haber Sonu!");
      return;
    }
    for (APINewsDetail element in response.response!.news) {
      newsList.add(
        News(
          newsID: element.newsID,
          newsTitle: element.title,
          author: element.newsOwner.displayname,
          newsImage: element.media.mediaURL.minURL,
          newssummary: element.summary,
          authoravatar: element.newsOwner.avatar.minURL,
          newsViews: element.views,
        ),
      );
    }
    newspage++;
    eventlistProcces.value = false;
  }
}
