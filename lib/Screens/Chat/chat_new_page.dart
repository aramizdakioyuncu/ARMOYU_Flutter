import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatNewPage extends StatefulWidget {
  const ChatNewPage({super.key});

  @override
  State<ChatNewPage> createState() => _ChatNewPageState();
}

int chatnewpage = 1;
bool _chatFriendsprocess = false;
bool _isFirstFetch = true;
List<Chat> _newchatList = [];

List<Chat> _filteredItems = []; // Filtrelenmiş liste

TextEditingController _newchatcontroller = TextEditingController();

class _ChatNewPageState extends State<ChatNewPage>
    with AutomaticKeepAliveClientMixin<ChatNewPage> {
  final ScrollController chatScrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (_isFirstFetch) {
      getchatfriendlist();
    }

    chatScrollController.addListener(() {
      if (chatScrollController.position.pixels >=
          chatScrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getchatfriendlist();
      }
    });

    _newchatcontroller.addListener(() {
      String newText = _newchatcontroller.text.toLowerCase();
      // Filtreleme işlemi
      _filteredItems = _newchatList.where((item) {
        return item.user.displayName!.toLowerCase().contains(newText);
      }).toList();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // newchatcontroller.dispose();
    super.dispose();
  }

  Future<void> getchatfriendlist() async {
    if (_chatFriendsprocess) {
      return;
    }
    _chatFriendsprocess = true;
    _isFirstFetch = false;
    if (mounted) {
      setState(() {});
    }
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getnewchatfriendlist(chatnewpage);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _chatFriendsprocess = false;
      getchatfriendlist();
      return;
    }

    if (chatnewpage == 1) {
      _newchatList.clear();
    }
    if (response["icerik"].length == 0) {
      log("Sohbet Arkadaşlarım Sayfa Sonu");

      _chatFriendsprocess = true;
      _isFirstFetch = false;

      if (mounted) {
        setState(() {});
      }
      return;
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          _newchatList.add(
            Chat(
              chatID: 1,
              chatType: "ozel",
              chatNotification: false,
              user: User(
                  userID: response["icerik"][i]["kullid"],
                  displayName: response["icerik"][i]["adisoyadi"],
                  lastlogin: response["icerik"][i]["songiris"],
                  lastloginv2: response["icerik"][i]["songiris"],
                  avatar: Media(
                    mediaID: response["icerik"][i]["kullid"],
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
    _filteredItems = _newchatList;
    chatnewpage++;
    _chatFriendsprocess = false;
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
      body: Column(
        children: [
          Container(
            color: ARMOYU.appbarColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ARMOYU.bodyColor,
                ),
                child: TextField(
                  controller: _newchatcontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    hintText: 'Ara',
                  ),
                  style: TextStyle(
                    color: ARMOYU.color,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: !_isFirstFetch && !_chatFriendsprocess
                        ? const Text("Arkadaş listesi boş")
                        : const CupertinoActivityIndicator(),
                  )
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    controller: chatScrollController,
                    itemBuilder: (context, index) {
                      return _filteredItems[index].listtilenewchat(context);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
