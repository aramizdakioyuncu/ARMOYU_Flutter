import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:flutter/material.dart';

class ChatNewPage extends StatefulWidget {
  const ChatNewPage({super.key});

  @override
  State<ChatNewPage> createState() => _ChatNewPageState();
}

int page = 1;
bool chatFriendsprocess = false;
bool isFirstFetch = true;
List<Chat> aaa = [];

final ScrollController _scrollController = ScrollController();

class _ChatNewPageState extends State<ChatNewPage>
    with AutomaticKeepAliveClientMixin<ChatNewPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (isFirstFetch) {
      getchatfriendlist();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getchatfriendlist();
      }
    });
  }

  Future<void> getchatfriendlist() async {
    if (chatFriendsprocess) {
      return;
    }
    setState(() {
      chatFriendsprocess = true;
      isFirstFetch = false;
    });
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getnewchatfriendlist(page);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      setState(() {
        chatFriendsprocess = false;
      });
      getchatfriendlist();
      return;
    }

    if (page == 1) {
      aaa.clear();
    }
    if (response["icerik"].length == 0) {
      setState(() {
        chatFriendsprocess = true;
      });
      log("Sayfasonu");
      //Sayfa sonudur
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          aaa.add(
            Chat(
              chatID: 1,
              displayName: response["icerik"][i]["adisoyadi"],
              avatar: response["icerik"][i]["avatar"],
              userID: response["icerik"][i]["kullid"],
              chatType: "ozel",
              lastonlinetime: response["icerik"][i]["songiris"],
              chatNotification: false,
            ),
          );
        });
      }
    }
    setState(() {
      page++;
      chatFriendsprocess = false;
    });
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
        controller: _scrollController,
        itemBuilder: (context, index) {
          return aaa[index].listtilenewchat(context);
        },
      ),
    );
  }
}
