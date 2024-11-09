import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/news.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/news.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
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
    FunctionsNews function = FunctionsNews(currentUser: user.value!);
    Map<String, dynamic> response = await function.fetch(newspage.value);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      eventlistProcces.value = false;
      //Tekrar çekmeyi dene
      getnewslist();
      return;
    }

    if (newspage.value == 1) {
      newsList.clear();
    }

    if (response['icerik'].length == 0) {
      eventlistProcces.value = true;
      log("Haner Sonu!");
      return;
    }
    for (dynamic element in response['icerik']) {
      newsList.add(
        News(
          newsID: element["haberID"],
          newsTitle: element["haberbaslik"],
          newsContent: "",
          author: element["yazar"],
          newsImage: element["resimminnak"],
          newssummary: element["ozet"],
          authoravatar: element["yazaravatar"],
          newsViews: element["goruntulen"],
        ),
      );
    }
    newspage++;
    eventlistProcces.value = false;
  }
}
