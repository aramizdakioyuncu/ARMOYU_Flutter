import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
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

    FunctionsProfile f = FunctionsProfile(
      currentUser: currentUser.value!,
    );
    Map<String, dynamic> response = await f.friendlist(
      currentUser.value!.userID!,
      chatnewpage.value,
    );
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      chatFriendsprocess.value = false;
      await getchatfriendlist();
      return;
    }

    if (chatnewpage.value == 1) {
      newchatList.value = [];

      currentUser.value!.myFriends = <User>[].obs;
    }
    if (response["icerik"].length == 0) {
      log("Sohbet Arkadaşlarım Sayfa Sonu");

      chatFriendsprocess.value = true;
      isFirstFetch.value = false;

      return;
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      currentUser.value!.myFriends!.add(
        User(
          userID: response["icerik"][i]["oyuncuID"],
          userName: response["icerik"][i]["oyuncukullaniciad"],
          displayName: response["icerik"][i]["oyuncuad"],
          status: response["icerik"][i]["oyuncudurum"] == 1 ? true : false,
          level: response["icerik"][i]["oyunculevel"],
          lastlogin: response["icerik"][i]["songiris"] != null
              ? Rx<String>(response["icerik"][i]["songiris"])
              : null,
          lastloginv2: response["icerik"][i]["songiris"] != null
              ? Rx<String>(response["icerik"][i]["songiris"])
              : null,
          ismyFriend: response["icerik"][i]["oyuncuarkadasdurum"] == 1
              ? true.obs
              : false.obs,
          avatar: Media(
            mediaID: response["icerik"][i]["oyuncuID"],
            mediaURL: MediaURL(
              bigURL: Rx<String>(response["icerik"][i]["oyuncuavatar"]),
              normalURL: Rx<String>(response["icerik"][i]["oyuncufakavatar"]),
              minURL: Rx<String>(response["icerik"][i]["oyuncuminnakavatar"]),
            ),
          ),
        ),
      );
    }

    filteredItems.value = currentUser.value!.myFriends;
    chatnewpage++;
    chatFriendsprocess.value = false;

    currentUser.refresh();
  }
}
