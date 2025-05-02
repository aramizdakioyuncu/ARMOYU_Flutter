import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/functions/page_functions.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/mainpage/_main/controllers/main_controller.dart';

import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:armoyu_widgets/sources/social/bundle/story_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocailPageController extends GetxController {
  late final ScrollController scrollController;

  late StoryWidgetBundle widgetstory; // Reaktif liste
  late PostsWidgetBundle widgetposts;
  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rxn(),
    ),
  );
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    final mainController = Get.find<MainPageController>(
      tag: currentUserAccounts.value.user.value.userID.toString(),
    );

    scrollController = mainController.homepageScrollControllerv2.value;

    initpost();
  }

  initpost() async {
    widgetstory = API.widgets.social.widgetStorycircle(
      cachedStoryList: currentUserAccounts.value.widgetStoriescard,
      onStoryUpdated: (updatedPosts) {
        currentUserAccounts.value.widgetStoriescard = updatedPosts;
        log("--------------->>  updatedStory : ${updatedPosts.length} || widgetStories: ${currentUserAccounts.value.widgetStoriescard?.length}");
      },
    );

    widgetposts = API.widgets.social.posts(
      cachedpostsList: currentUserAccounts.value.widgetPosts,
      onPostsUpdated: (updatedPosts) {
        currentUserAccounts.value.widgetPosts = updatedPosts;
        log("--------------->>  updatedPosts : ${updatedPosts.length} || widgetPosts: ${currentUserAccounts.value.widgetPosts?.length}");
      },
      context: Get.context!,
      scrollController: scrollController,
      shrinkWrap: true,
      profileFunction: ({
        required avatar,
        required banner,
        required displayname,
        required userID,
        required username,
      }) {
        log('$userID $username');
        PageFunctions().pushProfilePage(
          Get.context!,
          User(
            userID: userID,
            userName: Rx(username),
          ),
        );
      },
    );
  }

  //Sayfa Yenilenme işlemi
  Future<void> handleRefresh() async {
    log("Sayfa Yenileniyor...");
    isLoading.value = true;
    await widgetposts.refresh();
    await widgetstory.refresh();
    isLoading.value = false;
  }
}
