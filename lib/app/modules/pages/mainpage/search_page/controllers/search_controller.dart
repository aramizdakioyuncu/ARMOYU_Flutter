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
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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
    NewsListResponse response = await f.fetch(page: 1);
    if (!response.result.status) {
      ARMOYUWidget.toastNotification(response.result.description.toString());
      eventlistProcces.value = false;
      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      getnewslist();
      return;
    }

    newsList.clear();

    for (var element in response.response!.news) {
      newsList.add(
        News(
          newsID: element.newsID,
          newsTitle: element.title,
          newsContent: "",
          author: element.newsOwner.displayname,
          newsImage: element.newsOwner.avatar.minURL,
          newssummary: element.summary,
          authoravatar: element.newsOwner.avatar.minURL,
          newsViews: element.views,
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
      SearchListResponse response =
          await f.searchengine(searchword: text, page: 1);
      if (!response.result.status) {
        log(response.result.description);
        return;
      }

      try {
        widgetSearch.value = [];
      } catch (e) {
        log(e.toString());
      }

      //Eğer cevap gelene kadar yeni bir şeyler yazmışsa
      if (text != controller.text) {
        return;
      }

      for (var element in response.response!.search) {
        try {
          widgetSearch.add(
            ListTile(
              leading: CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(element.avatar!),
                backgroundColor: Colors.black,
              ),
              title: CustomText.costum1(element.value, weight: FontWeight.bold),
              trailing: element.turu == "oyuncu"
                  ? const Icon(Icons.person)
                  : element.turu == "okullar"
                      ? const Icon(Icons.school)
                      : const Icon(Icons.groups),
              onTap: () {
                if (element.turu == "oyuncu") {
                  PageFunctions functions = PageFunctions(
                    currentUser: currentUserAccounts.user.value,
                  );
                  functions.pushProfilePage(
                    Get.context!,
                    User(
                      userID: element.id,
                    ),
                    ScrollController(),
                  );
                } else if (element.turu == "gruplar") {
                  Get.toNamed("/group/detail", arguments: {
                    "user": currentUserAccounts.user.value,
                    "group": Group(groupID: element.id),
                  });
                } else if (element.turu == "okullar") {
                  Get.toNamed("/school", arguments: {
                    "schoolID": element.id,
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
