import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/functions/page_functions.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/pages/mainpage/_main/controllers/main_controller.dart';

import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:armoyu_widgets/sources/social/bundle/posts_bundle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocailPageController extends GetxController {
  final ScrollController scrollController;

  SocailPageController({
    required this.scrollController,
  });

  late final ScrollController _scrollController;

  Rxn<Widget> widgetstory = Rxn(); // Reaktif liste
  // Rxn<Widget> widgetposts = Rxn(); // Reaktif liste
  late PostsWidgetBundle widgetposts;
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

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    final mainController = Get.find<MainPageController>(
      tag: currentUserAccounts.value.user.value.userID.toString(),
    );

    _scrollController = mainController.homepageScrollControllerv2.value;

    // ScrollController'ı dinle
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        log("qqqq");
        await widgetposts.loadMore();
      }
    });

    widgetstory.value = API.widgets.social.widgetStorycircle();
    widgetposts = API.widgets.social.posts(
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
    log("Sayfa Yenilendi");

    await widgetposts.refresh();
  }
}
