// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, must_call_super, prefer_interpolation_to_compose_strings, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:developer';

import 'package:ARMOYU/Functions/API_Functions/profile.dart';
import 'package:ARMOYU/Widgets/userlist.dart';
import 'package:flutter/material.dart';

class FriendlistPage extends StatefulWidget {
  int userid; // Zorunlu olarak alınacak veri
  String username; // Zorunlu olarak alınacak veri

  FriendlistPage({
    required this.userid,
    required this.username,
  });
  @override
  _FriendlistPageState createState() => _FriendlistPageState();
}

class _FriendlistPageState extends State<FriendlistPage>
    with
        AutomaticKeepAliveClientMixin<FriendlistPage>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  List<Widget> Widget_userlist = [];

  final ScrollController scrollController = ScrollController();
  int pagecounter = 1;
  bool proccessStatus = false;
  @override
  void initState() {
    super.initState();

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
    log(page.toString());
    log(widget.userid.toString());
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
          Widget_userlist.add(UserListWidget(
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
    return Scaffold(
      appBar: AppBar(
          title: Title(color: Colors.black, child: Text(widget.username))),
      backgroundColor: Colors.grey.shade900,
      body: ListView.builder(
        controller: scrollController,
        itemCount: Widget_userlist.length,
        itemBuilder: (context, index) {
          return Widget_userlist[index];
        },
      ),
    );
  }
}
