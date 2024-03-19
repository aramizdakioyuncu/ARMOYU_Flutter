import 'dart:developer';

import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Widgets/userlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendlistPage extends StatefulWidget {
  final int userid; // Zorunlu olarak alınacak veri
  final String username; // Zorunlu olarak alınacak veri

  const FriendlistPage({
    super.key,
    required this.userid,
    required this.username,
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
  List<Widget> widgetUserlist = [];

  final ScrollController scrollController = ScrollController();
  int pagecounter = 1;
  bool proccessStatus = false;
  @override
  void initState() {
    super.initState();
    log("ID " + widget.userid.toString());

    fetchfriend(pagecounter);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchfriend(pagecounter);
      }
    });
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
    FunctionsProfile f = FunctionsProfile();
    Map<String, dynamic> response = await f.friendlist(widget.userid, page);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      int userID = response["icerik"][i]["oyuncuID"];
      String displayname = response["icerik"][i]["oyuncuad"];
      String userlogin = response["icerik"][i]["oyuncukullaniciad"];
      String avatar = response["icerik"][i]["oyuncuminnakavatar"];
      int isFriend = response["icerik"][i]["oyuncuarkadasdurum"];

      bool isFriendStatus = true;
      if (isFriend == 0) {
        isFriendStatus = false;
      }

      if (mounted) {
        setState(() {
          widgetUserlist.add(UserListWidget(
            userID: userID,
            displayname: displayname,
            profileImageUrl: avatar,
            username: userlogin,
            isFriend: isFriendStatus,
          ));
        });
      }
    }

    pagecounter++;
    proccessStatus = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
          title: Title(color: Colors.black, child: Text(widget.username))),
      backgroundColor: Colors.grey.shade900,
      body: widgetUserlist.isEmpty
          ? const Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              controller: scrollController,
              itemCount: widgetUserlist.length,
              itemBuilder: (context, index) {
                return widgetUserlist[index];
              },
            ),
    );
  }
}
