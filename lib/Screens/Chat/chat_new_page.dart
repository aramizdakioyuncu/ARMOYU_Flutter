import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:flutter/material.dart';

class ChatNewPage extends StatefulWidget {
  const ChatNewPage({
    super.key,
  });

  @override
  State<ChatNewPage> createState() => _ChatNewPageState();
}

List<Chat> aaa = [];

class _ChatNewPageState extends State<ChatNewPage>
    with AutomaticKeepAliveClientMixin<ChatNewPage> {
  bool chatfriendprocess = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    getchatfriendlist();
  }

  Future<void> getchatfriendlist() async {
    if (chatfriendprocess) {
      return;
    }
    chatfriendprocess = true;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getnewchatfriendlist(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      chatfriendprocess = false;
      getchatfriendlist();
      return;
    }
    aaa.clear();
    for (int i = 0; i < response["icerik"].length; i++) {
      setState(
        () {
          aaa.add(
            Chat(
              chatID: 1,
              displayName: response["icerik"][i]["adisoyadi"],
              avatar: response["icerik"][i]["avatar"],
              userID: response["icerik"][i]["kullid"],
              chatType: "ozel",
              lastonlinetime: response["icerik"][i]["songiris"],
            ),
          );
        },
      );
    }
    chatfriendprocess = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text("Yeni Sohbet"),
      ),
      body: ListView.builder(
        itemCount: aaa.length,
        itemBuilder: (context, index) {
          return aaa[index].listtilenewchat(context);
        },
      ),
    );
  }
}
