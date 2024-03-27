import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:flutter/material.dart';

class ChatNewPage extends StatefulWidget {
  const ChatNewPage({super.key});

  @override
  State<ChatNewPage> createState() => _ChatNewPageState();
}

int chatnewpage = 1;
bool chatFriendsprocess = false;
bool isFirstFetch = true;
List<Chat> newchatList = [];

class _ChatNewPageState extends State<ChatNewPage>
    with AutomaticKeepAliveClientMixin<ChatNewPage> {
  final ScrollController chatScrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (isFirstFetch) {
      getchatfriendlist();
    }

    chatScrollController.addListener(() {
      if (chatScrollController.position.pixels >=
          chatScrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getchatfriendlist();
      }
    });
  }

  Future<void> getchatfriendlist() async {
    if (chatFriendsprocess) {
      return;
    }
    chatFriendsprocess = true;
    isFirstFetch = false;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getnewchatfriendlist(chatnewpage);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      chatFriendsprocess = false;
      getchatfriendlist();
      return;
    }

    if (chatnewpage == 1) {
      newchatList.clear();
    }
    if (response["icerik"].length == 0) {
      chatFriendsprocess = true;
      log("Sohbet Arkadaşlarım Sayfa Sonu");
      return;
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          newchatList.add(
            Chat(
              chatID: 1,
              chatType: "ozel",
              lastonlinetime: response["icerik"][i]["songiris"],
              chatNotification: false,
              user: User(
                  userID: response["icerik"][i]["kullid"],
                  displayName: response["icerik"][i]["adisoyadi"],
                  avatar: Media(
                    mediaURL: MediaURL(
                      bigURL: response["icerik"][i]["avatar"],
                      normalURL: response["icerik"][i]["avatar"],
                      minURL: response["icerik"][i]["avatar"],
                    ),
                  )),
            ),
          );
        });
      }
    }
    chatnewpage++;
    chatFriendsprocess = false;
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
        itemCount: newchatList.length,
        controller: chatScrollController,
        itemBuilder: (context, index) {
          return newchatList[index].listtilenewchat(context);
        },
      ),
    );
  }
}
