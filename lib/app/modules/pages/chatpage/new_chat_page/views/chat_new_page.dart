import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/profile.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatNewPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;

  const ChatNewPage({
    super.key,
    required this.currentUserAccounts,
  });
  @override
  State<ChatNewPage> createState() => _ChatNewPageState();
}

List<Chat> _newchatList = [];

List<User> _filteredItems = []; // Filtrelenmiş liste

class _ChatNewPageState extends State<ChatNewPage>
    with AutomaticKeepAliveClientMixin<ChatNewPage> {
  @override
  bool get wantKeepAlive => true;

  int _chatnewpage = 1;
  bool _chatFriendsprocess = false;
  bool _isFirstFetch = true;

  final TextEditingController _newchatcontroller = TextEditingController();

  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (_isFirstFetch) {
      if (widget.currentUserAccounts.user.myFriends != null) {
        if (widget.currentUserAccounts.user.myFriends!.isNotEmpty) {
          _filteredItems = widget.currentUserAccounts.user.myFriends!;
        } else {
          getchatfriendlist();
        }
      } else {
        getchatfriendlist();
      }
    }

    _chatScrollController.addListener(() {
      if (_chatScrollController.position.pixels >=
          _chatScrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getchatfriendlist();
      }
    });

    _newchatcontroller.addListener(() {
      String newText = _newchatcontroller.text.toLowerCase();
      // Filtreleme işlemi
      _filteredItems = widget.currentUserAccounts.user.myFriends!.where((item) {
        return item.displayName!.toLowerCase().contains(newText);
        // return item.user.displayName!.toLowerCase().contains(newText);
      }).toList();
      if (mounted) {
        setState(() {});
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
    // newchatcontroller.dispose();
    super.dispose();
  }

  Future<void> getchatfriendlist({
    bool fecthRestart = false,
  }) async {
    if (fecthRestart) {
      _chatnewpage = 1;
      _chatFriendsprocess = false;
    }

    if (_chatFriendsprocess) {
      return;
    }

    _chatFriendsprocess = true;
    _isFirstFetch = false;
    setstatefunction();

    if (!fecthRestart && widget.currentUserAccounts.user.myFriends != null) {
      int pageCount =
          (widget.currentUserAccounts.user.myFriends!.length / 50).ceil();
      log(pageCount.toString());

      _chatnewpage = pageCount;
      _chatnewpage++;
    }

    FunctionsProfile f =
        FunctionsProfile(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await f.friendlist(
        widget.currentUserAccounts.user.userID!, _chatnewpage);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _chatFriendsprocess = false;
      await getchatfriendlist();
      return;
    }

    if (_chatnewpage == 1) {
      _newchatList.clear();

      widget.currentUserAccounts.user.myFriends = [];
    }
    if (response["icerik"].length == 0) {
      log("Sohbet Arkadaşlarım Sayfa Sonu");

      _chatFriendsprocess = true;
      _isFirstFetch = false;

      setstatefunction();
      return;
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      widget.currentUserAccounts.user.myFriends!.add(
        User(
          userID: response["icerik"][i]["oyuncuID"],
          userName: response["icerik"][i]["oyuncukullaniciad"],
          displayName: response["icerik"][i]["oyuncuad"],
          status: response["icerik"][i]["oyuncudurum"] == 1 ? true : false,
          level: response["icerik"][i]["oyunculevel"],
          lastlogin: response["icerik"][i]["songiris"],
          lastloginv2: response["icerik"][i]["songiris"],
          ismyFriend:
              response["icerik"][i]["oyuncuarkadasdurum"] == 1 ? true : false,
          avatar: Media(
            mediaID: response["icerik"][i]["oyuncuID"],
            mediaURL: MediaURL(
              bigURL: response["icerik"][i]["oyuncuavatar"],
              normalURL: response["icerik"][i]["oyuncufakavatar"],
              minURL: response["icerik"][i]["oyuncuminnakavatar"],
            ),
          ),
        ),
      );
    }

    setstatefunction();

    _filteredItems = widget.currentUserAccounts.user.myFriends!;
    _chatnewpage++;
    _chatFriendsprocess = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        title: const Text("Yeni Sohbet"),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _chatScrollController,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async => await getchatfriendlist(fecthRestart: true),
          ),
          SliverToBoxAdapter(
            child: Container(
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
          ),
          if (_filteredItems.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: CachedNetworkImageProvider(
                            _filteredItems[index].avatar!.mediaURL.minURL,
                          ),
                        ),
                        title: CustomText.costum1(
                            _filteredItems[index].displayName!),
                        tileColor: ARMOYU.appbarColor,
                        trailing:
                            Text(_filteredItems[index].lastloginv2.toString()),
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (pagecontext) => ChatDetailPage(
                          //       chat: Chat(
                          //         user: _filteredItems[index],
                          //         chatNotification: false,
                          //       ),
                          //       currentUserAccounts: widget.currentUserAccounts,
                          //     ),
                          //   ),
                          // );

                          Get.toNamed("/chat/detail", arguments: {
                            "chat": Chat(
                              user: _filteredItems[index],
                              chatNotification: false,
                            )
                          });
                        },
                      ),
                      const SizedBox(height: 1),
                    ],
                  );
                },
                childCount: _filteredItems.length,
              ),
            ),
        ],
      ),
    );
  }
}
