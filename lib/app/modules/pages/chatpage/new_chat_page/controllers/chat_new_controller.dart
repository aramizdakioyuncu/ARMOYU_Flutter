import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatNewController extends GetxController {
  final UserAccounts currentUserAccounts;
  ChatNewController({required this.currentUserAccounts});

  var newchatList = <Chat>[].obs;

  var filteredItems = <User>[].obs; // Filtrelenmiş liste

  var newchatcontroller = TextEditingController().obs;

  var chatScrollController = ScrollController().obs;

  var chatnewpage = 1.obs;
  var chatFriendsprocess = false.obs;
  var isFirstFetch = true.obs;

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

    if (!fecthRestart && currentUserAccounts.user.myFriends != null) {
      int pageCount = (currentUserAccounts.user.myFriends!.length / 50).ceil();
      log(pageCount.toString());

      chatnewpage.value = pageCount;
      chatnewpage++;
    }

    FunctionsProfile f =
        FunctionsProfile(currentUser: currentUserAccounts.user);
    Map<String, dynamic> response =
        await f.friendlist(currentUserAccounts.user.userID!, chatnewpage.value);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      chatFriendsprocess.value = false;
      await getchatfriendlist();
      return;
    }

    if (chatnewpage.value == 1) {
      newchatList.value = [];

      currentUserAccounts.user.myFriends = [];
    }
    if (response["icerik"].length == 0) {
      log("Sohbet Arkadaşlarım Sayfa Sonu");

      chatFriendsprocess.value = true;
      isFirstFetch.value = false;

      return;
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      currentUserAccounts.user.myFriends!.add(
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
          ismyFriend:
              response["icerik"][i]["oyuncuarkadasdurum"] == 1 ? true : false,
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

    filteredItems.value = currentUserAccounts.user.myFriends!;
    chatnewpage++;
    chatFriendsprocess.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    if (isFirstFetch.value) {
      if (currentUserAccounts.user.myFriends != null) {
        if (currentUserAccounts.user.myFriends!.isNotEmpty) {
          filteredItems.value = currentUserAccounts.user.myFriends!;
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
      filteredItems.value = currentUserAccounts.user.myFriends!.where((item) {
        return item.displayName!.toLowerCase().contains(newText);
        // return item.user.displayName!.toLowerCase().contains(newText);
      }).toList();
    });
  }
}
