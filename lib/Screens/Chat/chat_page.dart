import 'dart:async';
import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:ARMOYU/Models/Chat/chat_message.dart';
import 'package:ARMOYU/Screens/Chat/chat_new_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/functions_service.dart';

class ChatPage extends StatefulWidget {
  final bool appbar;
  const ChatPage({
    super.key,
    required this.appbar,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final ScrollController _scrollController = ScrollController();

List<Chat> chatlist = [];

bool chatsearchprocess = false;

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    if (!chatsearchprocess) {
      getchat();
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      getchat();
    });
  }

  Future<void> getchat() async {
    if (chatsearchprocess) {
      return;
    }
    chatsearchprocess = true;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getchats(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      chatsearchprocess = false;
      getchat();
      return;
    }
    chatlist.clear();
    for (int i = 0; i < response["icerik"].length; i++) {
      String sonmesaj = response["icerik"][i]["sonmesaj"].toString();
      if (sonmesaj == "null") {
        sonmesaj = "";
      }
      setState(() {
        bool notification = false;
        if (response["icerik"][i]["bildirim"] == 1) {
          notification = true;
        }
        chatlist.add(
          Chat(
            chatID: 1,
            displayName: response["icerik"][i]["adisoyadi"],
            avatar: response["icerik"][i]["foto"],
            userID: response["icerik"][i]["kullid"],
            lastonlinetime: response["icerik"][i]["songiris"],
            lastmessage: ChatMessage(
              avatar: "",
              messageContext: sonmesaj,
              displayName: "",
              messageID: 1,
              userID: 1,
              isMe: false,
            ),
            chatType: response["icerik"][i]["sohbetturu"],
            chatNotification: notification,
          ),
        );
      });
    }
    chatsearchprocess = false;
    // widget.searchController.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: widget.appbar
          ? AppBar(
              title: const Text("Sohbetler"),
              automaticallyImplyLeading: false,
              backgroundColor: ARMOYU.appbarColor,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: chatlist.isEmpty
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  log("s");
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatlist.length,
                  itemBuilder: (BuildContext context, index) {
                    return chatlist[index].listtilechat(context);
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "NewChatButton",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatNewPage(),
            ),
          );
        },
        backgroundColor: ARMOYU.buttonColor,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }
}
