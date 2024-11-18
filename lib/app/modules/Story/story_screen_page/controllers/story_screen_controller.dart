import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Story/story.dart';
import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/story_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryScreenController extends GetxController {
  late var timer = Rxn<Timer>();
  late var pageControllerStory = Rxn<PageController>();
  late var pageController = Rxn<PageController>();
  var initialStoryIndex = Rx<int>(0);
  var containerWidth = Rx<double>(0);
  var containerWidthValue = Rx<double>(0);
  var isPaused = false.obs;

  var viewlistProcess = false.obs;
  var storyviewProcess = false.obs;
  var firststoryviewProcess = false.obs;
  var viewerlist = <User>[].obs;

  late var storyIndex = Rxn<int>();
  late var storyList = RxList<StoryList>().obs;

  late var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    Map<String, dynamic> arguments = Get.arguments;

    storyIndex.value = arguments['storyIndex'];
    storyList.value = arguments['storyList'];
    pageControllerStory.value = PageController(initialPage: storyIndex.value!);
    pageController.value = PageController(
      initialPage: initialStoryIndex.value,
    );

    startTimer();
    pageController.value!.addListener(() {
      if (pageController.value!.page ==
          pageController.value!.page?.roundToDouble()) {
        containerWidth.value = 1;
        startAnimation();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer.value!.cancel();
  }

  Future<void> storyview(Story story) async {
    if (firststoryviewProcess.value) {
      return;
    }
    if (storyviewProcess.value) {
      return;
    }

    storyviewProcess.value = true;

    StoryAPI funct = StoryAPI(currentUser: currentUser.value!);
    Map<String, dynamic> response = await funct.view(storyID: story.storyID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      storyviewProcess.value = false;
      firststoryviewProcess.value = true;
      return;
    }
    firststoryviewProcess.value = true;

    storyviewProcess.value = false;
    story.isView = 1;
  }

  void onTapeventStory() {
    if (initialStoryIndex.value + 1 <
        storyList.value[storyIndex.value!].story!.length) {
      log("Story içi değişiklik");
      initialStoryIndex.value++;
      pageController.value!.jumpToPage(initialStoryIndex.value);
      timer.value!.cancel();

      startTimer();
      return;
    }

    if (initialStoryIndex.value + 1 ==
            storyList.value[storyIndex.value!].story!.length &&
        storyIndex.value! + 1 < storyList.value.length) {
      log("Storyler arası Değişiklik");

      storyIndex.value = storyIndex.value! + 1;
      initialStoryIndex.value = 0;
      pageControllerStory.value!.jumpToPage(storyIndex.value!);

      timer.value!.cancel();

      startTimer();
      return;
    }

    if (storyList.value[storyIndex.value!].story!.length ==
            initialStoryIndex.value + 1 &&
        storyList.value.length == storyIndex.value! + 1) {
      log("Story Çıkış");

      timer.value!.cancel();

      Get.back();
      return;
    }
  }

  void startTimer() {
    containerWidth.value = 0;
    containerWidthValue.value = 0;

    timer.value = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!isPaused.value) {
        containerWidth.value += 1;

        containerWidthValue.value = containerWidth.value / Get.width;
        storyList.refresh();
        if (containerWidth.value >= Get.width) {
          onTapeventStory();
        }
      }
    });
  }

  void startAnimation() {
    isPaused.value = false;
  }

  void stopAnimation() {
    isPaused.value = true;
  }

  Future<void> fetchstoryViewlist(int storyID) async {
    if (viewlistProcess.value) {
      return;
    }

    viewlistProcess.value = true;
    StoryAPI funct = StoryAPI(currentUser: currentUser.value!);
    Map<String, dynamic> response = await funct.fetchviewlist(storyID: storyID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      viewlistProcess.value = false;
      return;
    }

    viewerlist.clear();

    for (var element in response["icerik"]) {
      viewerlist.add(
        User(
          userName: element["hgoruntuleyen_kullaniciad"],
          displayName: element["hgoruntuleyen_adsoyad"],
          status: element["hgoruntuleyen_begenme"] == 1 ? true : false,
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element["hgoruntuleyen_avatar"]),
              normalURL: Rx<String>(element["hgoruntuleyen_avatar"]),
              minURL: Rx<String>(element["hgoruntuleyen_avatar"]),
            ),
          ),
        ),
      );
    }

    viewlistProcess.value = false;
  }

  Future<void> viewmystoryviewlist() async {
    stopAnimation();
    fetchstoryViewlist(storyList
        .value[storyIndex.value!].story![initialStoryIndex.value].storyID);
    final result = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      // backgroundColor: ARMOYU.bodyColor,
      context: Get.context!,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () async {},
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomText.costum1("Görüntüleyenler"),
                    const SizedBox(height: 5),
                    const Divider(),
                    Obx(
                      () => Expanded(
                        child: viewerlist.isEmpty
                            ? const CupertinoActivityIndicator()
                            : ListView.builder(
                                itemCount: viewerlist.length,
                                itemBuilder: (context, index) {
                                  return viewerlist[index].storyViewUserList(
                                    isLiked: viewerlist[index].status!,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      startAnimation();
    } else {
      startAnimation();
    }
  }
}
