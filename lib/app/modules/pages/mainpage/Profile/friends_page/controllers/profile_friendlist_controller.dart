import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileFriendlistController extends GetxController {
  var scrollController = ScrollController().obs;
  var pagecounter = 1.obs;
  var proccessStatus = false.obs;
  var firstproccessStatus = false.obs;

  var user =
      Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));
  var currentUserAccounts =
      Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));

  @override
  void onInit() {
    super.onInit();
    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    Map<String, dynamic> arguments = Get.arguments;
    UserAccounts userInfo = arguments["user"];

    // if (userInfo.user.value.userID ==
    //     currentUserAccounts.value.user.value.userID) {
    //   user.value = currentUserAccounts.value;
    // } else {
    //   user.value = userInfo;
    // }
    user.value = userInfo;

    fetchfriend();
    firstproccessStatus.value = true;

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
          scrollController.value.position.maxScrollExtent) {
        fetchfriend();
      }
    });
  }

  fetchfriend({bool refreshfetch = false}) async {
    if (proccessStatus.value) {
      return;
    }

    proccessStatus.value = true;

    // Verinin çekilmesi

    ProfileFriendListResponse response = await API.service.profileServices
        .friendlist(
            userID: user.value.user.value.userID!, page: pagecounter.value);

    if (!response.result.status) {
      log(response.result.description);
      return;
    }
    if (refreshfetch || pagecounter.value == 1) {
      pagecounter.value = 1;
      user.value.user.value.myFriends = RxList([]);
    }
    user.value.user.value.myFriends ??= RxList([]);

    for (var element in response.response!) {
      int userID = element.playerID;
      String displayname = element.displayName;
      String userlogin = element.username;
      String avatar = element.avatar.bigURL;
      String normalavatar = element.avatar.normalURL;
      String minavatar = element.avatar.minURL;
      int isFriend = element.friendshipStatus;

      var isFriendStatus = true.obs;
      if (isFriend == 0) {
        isFriendStatus.value = false;
      }

      User userfetch = User(
        userID: userID,
        displayName: displayname.obs,
        avatar: Media(
          mediaID: userID,
          mediaURL: MediaURL(
            bigURL: Rx<String>(avatar),
            normalURL: Rx<String>(normalavatar),
            minURL: Rx<String>(minavatar),
          ),
        ),
        userName: userlogin.obs,
        ismyFriend: isFriendStatus,

        // ismyFriend: false.obs,
      );

      // Arkadaş listesine ekleme
      if (user.value.user.value.myFriends != null) {
        user.value.user.value.myFriends?.add(userfetch);
      }
    }
    user.value.user.refresh();

    pagecounter.value++;
    proccessStatus.value = false;
  }
}
