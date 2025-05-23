import 'dart:async';
import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/group.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/functions/page_functions.dart';
import 'package:armoyu/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/sources/card/bundle/card_bundle.dart';
import 'package:armoyu_widgets/sources/card/widgets/card_widget.dart';
import 'package:armoyu_widgets/sources/news/bundle/news_bundle.dart';
import 'package:armoyu_widgets/widgets/Skeletons/search_skeleton.dart';
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

  Timer? searchTimer;

  var widgetSearch = <Widget>[].obs;

  late CardWidgetBundle widgetTPCard;
  late CardWidgetBundle widgetPOPCard;
  late NewsWidgetBundle widgetNews;

  @override
  void onInit() {
    super.onInit();

    widgetTPCard = API.widgets.cards.cardWidget(
      context: Get.context!,
      title: CustomCardType.playerXP,
      firstFetch: true,
      cachedCardList: currentUserAccounts.xpcard,
      onCardUpdated: (updatedCard) {
        currentUserAccounts.xpcard = updatedCard;
      },
      profileFunction: (
          {required avatar,
          required banner,
          required displayname,
          required userID,
          required username}) {
        PageFunctions().pushProfilePage(
          Get.context!,
          User(
            userID: userID,
            userName: Rx(username),
          ),
        );
      },
    );
    widgetPOPCard = API.widgets.cards.cardWidget(
      context: Get.context!,
      title: CustomCardType.playerPOP,
      firstFetch: true,
      cachedCardList: currentUserAccounts.popcard,
      onCardUpdated: (updatedCard) {
        currentUserAccounts.popcard = updatedCard;
      },
      profileFunction: (
          {required avatar,
          required banner,
          required displayname,
          required userID,
          required username}) {
        PageFunctions().pushProfilePage(
          Get.context!,
          User(
            userID: userID,
            userName: Rx(username),
          ),
        );
      },
    );

    searchController.addListener(_onSearchTextChanged);

    widgetNews = API.widgets.news.newsCarouselWidget(
      cachedNewsList: currentUserAccounts.newsList,
      onNewsUpdated: (updatedNews) {
        currentUserAccounts.newsList = updatedNews;
      },
      newsFunction: (news) {
        Get.toNamed("/news/detail", arguments: {
          "news": news,
        });
      },
    );
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

      SearchListResponse response = await API.service.searchServices
          .searchengine(searchword: text, page: 1);
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
                  PageFunctions functions = PageFunctions();
                  functions.pushProfilePage(
                    Get.context!,
                    User(userID: element.id),
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
