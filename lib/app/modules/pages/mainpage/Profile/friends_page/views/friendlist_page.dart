import 'dart:developer';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:ARMOYU/app/widgets/userlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendlistPage extends StatefulWidget {
  final UserAccounts currentUserAccounts; // Zorunlu olarak alınacak veri

  const FriendlistPage({
    super.key,
    required this.currentUserAccounts,
  });
  @override
  State<FriendlistPage> createState() => _FriendlistPageState();
}

class _FriendlistPageState extends State<FriendlistPage>
    with
        AutomaticKeepAliveClientMixin<FriendlistPage>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController scrollController = ScrollController();
  int pagecounter = 1;
  bool proccessStatus = false;
  @override
  void initState() {
    super.initState();
    log(widget.currentUserAccounts.user.userName.toString());

    fetchfriend(pagecounter);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchfriend(pagecounter);
      }
    });
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TEST.cancel();
    super.dispose();
  }

  fetchfriend(int page) async {
    if (proccessStatus) {
      return;
    }

    proccessStatus = true;
    FunctionsProfile f =
        FunctionsProfile(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response =
        await f.friendlist(widget.currentUserAccounts.user.userID!, page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    widget.currentUserAccounts.user.myFriends = [];

    for (int i = 0; i < response["icerik"].length; i++) {
      int userID = response["icerik"][i]["oyuncuID"];
      String displayname = response["icerik"][i]["oyuncuad"];
      String userlogin = response["icerik"][i]["oyuncukullaniciad"];
      String avatar = response["icerik"][i]["oyuncuavatar"];
      String normalavatar = response["icerik"][i]["oyuncufakavatar"];
      String minavatar = response["icerik"][i]["oyuncuminnakavatar"];
      int isFriend = response["icerik"][i]["oyuncuarkadasdurum"];

      bool isFriendStatus = true;
      if (isFriend == 0) {
        isFriendStatus = false;
      }

      widget.currentUserAccounts.user.myFriends!.add(User(
        userID: userID,
        displayName: displayname,
        avatar: Media(
          mediaID: userID,
          mediaURL: MediaURL(
            bigURL: avatar,
            normalURL: normalavatar,
            minURL: minavatar,
          ),
        ),
        userName: userlogin,
        ismyFriend: isFriendStatus,
      ));
      setstatefunction();
    }

    pagecounter++;
    proccessStatus = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomText.costum1(
            widget.currentUserAccounts.user.userName.toString()),
      ),
      body: widget.currentUserAccounts.user.myFriends == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : ListView.builder(
              controller: scrollController,
              itemCount: widget.currentUserAccounts.user.myFriends!.length,
              itemBuilder: (context, index) {
                return UserListWidget(
                  currentUserAccounts: widget.currentUserAccounts,
                  userID:
                      widget.currentUserAccounts.user.myFriends![index].userID!,
                  displayname: widget
                      .currentUserAccounts.user.myFriends![index].displayName!,
                  profileImageUrl: widget.currentUserAccounts.user
                      .myFriends![index].avatar!.mediaURL.minURL,
                  username: widget
                      .currentUserAccounts.user.myFriends![index].userName!,
                  isFriend: widget
                      .currentUserAccounts.user.myFriends![index].ismyFriend!,
                );
                // return widgetUserlist[index];
              },
            ),
    );
  }
}
