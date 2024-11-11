import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileFriendlistController extends GetxController {
  var scrollController = ScrollController().obs;
  var pagecounter = 1.obs;
  var proccessStatus = false.obs;
  var firstproccessStatus = false.obs;

  var user = Rx<UserAccounts>(UserAccounts(user: User().obs));
  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));

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
    FunctionsProfile f =
        FunctionsProfile(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response =
        await f.friendlist(user.value.user.value.userID!, pagecounter.value);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    if (refreshfetch || pagecounter.value == 1) {
      pagecounter.value = 1;
      user.value.user.value.myFriends = RxList([]);
    }
    user.value.user.value.myFriends ??= RxList([]);

    for (var element in response["icerik"]) {
      int userID = element["oyuncuID"];
      String displayname = element["oyuncuad"];
      String userlogin = element["oyuncukullaniciad"];
      String avatar = element["oyuncuavatar"];
      String normalavatar = element["oyuncufakavatar"];
      String minavatar = element["oyuncuminnakavatar"];
      int isFriend = element["oyuncuarkadasdurum"];

      var isFriendStatus = true.obs;
      if (isFriend == 0) {
        isFriendStatus.value = false;
      }

      User userfetch = User(
        userID: userID,
        displayName: displayname,
        avatar: Media(
          mediaID: userID,
          mediaURL: MediaURL(
            bigURL: Rx<String>(avatar),
            normalURL: Rx<String>(normalavatar),
            minURL: Rx<String>(minavatar),
          ),
        ),
        userName: userlogin,
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
