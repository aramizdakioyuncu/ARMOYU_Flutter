// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/profile/profile_friendlist.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatNewController extends GetxController {
  var newchatList = <Chat>[].obs;

  var filteredItems = Rxn<List<User>>();
  var newchatcontroller = TextEditingController().obs;

  var chatScrollController = ScrollController().obs;

  var chatnewpage = 1.obs;
  var chatFriendsprocess = false.obs;
  var isFirstFetch = true.obs;

  late var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;
    if (isFirstFetch.value) {
      if (currentUser.value!.myFriends != null) {
        if (currentUser.value!.myFriends!.isNotEmpty) {
          filteredItems.value = currentUser.value!.myFriends!;
        } else {
          getchatfriendlist();
        }
      } else {
        getchatfriendlist();
      }
    }

    chatScrollController.value.addListener(() {
      if (chatScrollController.value.position.pixels >=
          chatScrollController.value.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getchatfriendlist();
      }
    });

    newchatcontroller.value.addListener(() {
      String newText = newchatcontroller.value.text.toLowerCase();
      // Filtreleme işlemi
      filteredItems.value = (currentUser.value!.myFriends!.where((item) {
        return item.displayName!.toLowerCase().contains(newText);
        // return item.user.displayName!.toLowerCase().contains(newText);
      }).toList());
    });
  }

  Future<void> getchatfriendlist({
    bool fecthRestart = false,
  }) async {
    if (fecthRestart) {
      chatnewpage.value = 1;
      chatFriendsprocess.value = false;
    }

    if (chatFriendsprocess.value) {
      return;
    }

    chatFriendsprocess.value = true;
    isFirstFetch.value = false;

    if (!fecthRestart && currentUser.value!.myFriends != null) {
      int pageCount = (currentUser.value!.myFriends!.length / 50).ceil();
      log(pageCount.toString());

      chatnewpage.value = pageCount;
      chatnewpage++;
    }

    ProfileFriendListResponse response =
        await API.service.profileServices.friendlist(
      userID: currentUser.value!.userID!,
      page: chatnewpage.value,
    );
    if (!response.result.status) {
      log(response.result.description);
      chatFriendsprocess.value = false;
      await getchatfriendlist();
      return;
    }

    if (chatnewpage.value == 1) {
      newchatList.value = <Chat>[].obs;

      currentUser.value!.myFriends = <User>[].obs;
    }

    if (response.response!.isEmpty) {
      log("Sohbet Arkadaşlarım Sayfa Sonu");

      chatFriendsprocess.value = true;
      isFirstFetch.value = false;

      return;
    }

    for (APIProfileFriendlist element in response.response!) {
      currentUser.value!.myFriends!.add(
        User(
          userID: element.playerID,
          userName: Rx<String>(element.username),
          displayName: Rx<String>(element.displayName),
          status: element.status == 1 ? true : false,
          level: Rx<int>(element.level),
          // lastlogin:
          //     element.lastLogin != null ? Rx<String>(element.lastLogin) : null,
          // lastloginv2:
          //     element.lastLogin != null ? Rx<String>(element.lastLogin) : null,
          ismyFriend: element.friendshipStatus == 1 ? true.obs : false.obs,
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.avatar.bigURL),
              normalURL: Rx<String>(element.avatar.normalURL),
              minURL: Rx<String>(element.avatar.minURL),
            ),
          ),
        ),
      );
    }

    filteredItems.value = currentUser.value!.myFriends;
    chatnewpage.value++;
    chatFriendsprocess.value = false;

    currentUser.refresh();
  }
}
