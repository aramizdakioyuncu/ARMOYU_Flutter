import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/news.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/services/API/news_api.dart';
import 'package:ARMOYU/app/services/API/search_api.dart';
import 'package:ARMOYU/app/widgets/Skeletons/search_skeleton.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final UserAccounts currentUserAccounts;
  final TextEditingController searchController;
  SearchPageController({
    required this.currentUserAccounts,
    required this.searchController,
  });

  var postsearchprocess = false.obs;

  var eventlistProcces = false.obs;
  Timer? searchTimer;

  var widgetSearch = <Widget>[].obs;

  var firstProcces = false.obs;

  var newsList = <News>[].obs;
  late Rxn<Widget> widgetTPCard = Rxn<Widget>();
  late Rxn<Widget> widgetPOPCard = Rxn<Widget>();

  @override
  void onInit() {
    super.onInit();

    widgetTPCard.value = ARMOYUWidget(
      currentUserAccounts: currentUserAccounts,
      scrollController: ScrollController(),
      content: [],
      firstFetch: true,
    ).widgetTPlist();
    widgetPOPCard.value = ARMOYUWidget(
      currentUserAccounts: currentUserAccounts,
      scrollController: ScrollController(),
      content: [],
      firstFetch: true,
    ).widgetPOPlist();

    searchController.addListener(_onSearchTextChanged);

    if (!firstProcces.value) {
      getnewslist();
      firstProcces = true.obs;
    }
  }

  Future<void> getnewslist() async {
    if (eventlistProcces.value) {
      return;
    }
    eventlistProcces.value = true;
    NewsAPI f = NewsAPI(currentUser: currentUserAccounts.user.value);
    Map<String, dynamic> response = await f.fetch(page: 1);
    if (response["durum"] == 0) {
      ARMOYUWidget.toastNotification(response["aciklama"].toString());
      eventlistProcces.value = false;
      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      getnewslist();
      return;
    }

    newsList.clear();
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
    eventlistProcces.value = false;
  }

  void _onSearchTextChanged() {
    searchfunction(searchController, searchController.text);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadSkeletonpost() async {
    widgetSearch.value = [];
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
    widgetSearch.add(const SkeletonSearch());
  }

  Future<void> searchfunction(
    TextEditingController controller,
    String text,
  ) async {
    if (controller.text == "" || controller.text.isEmpty) {
      searchTimer?.cancel();
      widgetSearch.value = [];
      return;
    }

    searchTimer = Timer(const Duration(milliseconds: 500), () async {
      loadSkeletonpost();
      log("$text ${controller.text}");

      if (text != controller.text) {
        return;
      }
      SearchAPI f = SearchAPI(currentUser: currentUserAccounts.user.value);
      Map<String, dynamic> response =
          await f.searchengine(searchword: text, page: 1);
      if (response["durum"] == 0) {
        log(response["aciklama"]);
        return;
      }

      try {
        widgetSearch.value = [];
      } catch (e) {
        log(e.toString());
      }

      int dynamicItemCount = response["icerik"].length;
      //Eğer cevap gelene kadar yeni bir şeyler yazmışsa
      if (text != controller.text) {
        return;
      }
      for (int i = 0; i < dynamicItemCount; i++) {
        try {
          widgetSearch.add(
            ListTile(
              leading: CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(
                  response["icerik"][i]["avatar"],
                ),
                backgroundColor: Colors.black,
              ),
              title: CustomText.costum1(response["icerik"][i]["Value"],
                  weight: FontWeight.bold),
              trailing: response["icerik"][i]["turu"] == "oyuncu"
                  ? const Icon(Icons.person)
                  : response["icerik"][i]["turu"] == "okullar"
                      ? const Icon(Icons.school)
                      : const Icon(Icons.groups),
              onTap: () {
                if (response["icerik"][i]["turu"] == "oyuncu") {
                  PageFunctions functions = PageFunctions(
                    currentUser: currentUserAccounts.user.value,
                  );
                  functions.pushProfilePage(
                    Get.context!,
                    User(
                      userID: response["icerik"][i]["ID"],
                    ),
                    ScrollController(),
                  );
                } else if (response["icerik"][i]["turu"] == "gruplar") {
                  Get.toNamed("/group/detail", arguments: {
                    "user": currentUserAccounts.user.value,
                    "group": Group(groupID: response["icerik"][i]["ID"]),
                  });
                } else if (response["icerik"][i]["turu"] == "okullar") {
                  Get.toNamed("/school", arguments: {
                    "schoolID": response["icerik"][i]["ID"],
                  });
                }
              },
            ),
          );
          // });
        } catch (e) {
          log(e.toString());
        }
      }
    });
  }
}
