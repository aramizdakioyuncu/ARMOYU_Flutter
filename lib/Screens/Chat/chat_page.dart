import 'dart:async';
import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:ARMOYU/Models/Chat/chat_message.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Chat/chat_new_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/functions_service.dart';

class ChatPage extends StatefulWidget {
  final Function changePage;
  const ChatPage({
    super.key,
    required this.changePage,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

int chatPage = 1;
bool _chatsearchprocess = false;
bool _isFirstFetch = true;
List<Chat> _chatlist = [];
List<Chat> _filteredItems = [];
TextEditingController _chatcontroller = TextEditingController();

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  final ScrollController chatScrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    if (_isFirstFetch) {
      getchat();
    }

    _chatcontroller.addListener(() {
      String newText = _chatcontroller.text.toLowerCase();
      // Filtreleme işlemi
      _filteredItems = _chatlist.where((item) {
        return item.user.displayName!.toLowerCase().contains(newText);
      }).toList();
      if (mounted) {
        setState(() {});
      }
    });

    chatScrollController.addListener(() {
      if (chatScrollController.position.pixels >=
          chatScrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getchat();
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      getchat();
    });
  }

  Future<void> getchat() async {
    if (_chatsearchprocess) {
      return;
    }
    _chatsearchprocess = true;
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getchats(chatPage);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _chatsearchprocess = false;
      _isFirstFetch = false;
      getchat();
      return;
    }

    if (chatPage == 1) {
      _chatlist.clear();
    }

    if (response["icerik"].length == 0) {
      _chatsearchprocess = false;
      _isFirstFetch = false;

      log("Sohbet Liste Sonu!");
      if (mounted) {
        setState(() {});
      }
      return;
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      String sonmesaj = response["icerik"][i]["sonmesaj"].toString();
      if (sonmesaj == "null") {
        sonmesaj = "";
      }
      if (mounted) {
        setState(() {
          bool notification = false;
          if (response["icerik"][i]["bildirim"] == 1) {
            notification = true;
          }
          _chatlist.add(
            Chat(
              chatID: 1,
              user: User(
                userID: response["icerik"][i]["kullid"],
                displayName: response["icerik"][i]["adisoyadi"],
                lastlogin: response["icerik"][i]["songiris"],
                lastloginv2: response["icerik"][i]["songiris"],
                avatar: Media(
                  mediaID: response["icerik"][i]["kullid"],
                  mediaURL: MediaURL(
                    bigURL: response["icerik"][i]["foto"],
                    normalURL: response["icerik"][i]["foto"],
                    minURL: response["icerik"][i]["foto"],
                  ),
                ),
              ),
              lastmessage: ChatMessage(
                user: User(userID: 1, avatar: null, displayName: ""),
                messageContext: sonmesaj,
                messageID: 1,
                isMe: response["icerik"][i]["kullid"] == ARMOYU.appUser.userID
                    ? true
                    : false,
              ),
              chatType: response["icerik"][i]["sohbetturu"],
              chatNotification: notification,
            ),
          );
        });
      }
    }
    if (mounted) {
      setState(() {
        _filteredItems = _chatlist;
      });
    }

    _chatsearchprocess = false;
    _isFirstFetch = false;
    chatPage++;
  }

  bool searchStatus = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.changePage(0);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: searchStatus
            ? Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: ARMOYU.bodyColor,
                ),
                child: TextField(
                  controller: _chatcontroller,
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
              )
            : const Text("Sohbetler"),
        backgroundColor: ARMOYU.appbarColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                searchStatus = !searchStatus;
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: RefreshIndicator(
          onRefresh: () async {
            log("s");
          },
          child: _filteredItems.isEmpty
              ? Center(
                  child: !_isFirstFetch && !_chatsearchprocess
                      ? const Text("Sohbet geçmişi boş")
                      : const CupertinoActivityIndicator(),
                )
              : ListView.builder(
                  controller: chatScrollController,
                  itemCount: _filteredItems.length,
                  itemBuilder: (BuildContext context, index) {
                    return _filteredItems[index].listtilechat(context);
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
