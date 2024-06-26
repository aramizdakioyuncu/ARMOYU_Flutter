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
  final User currentUser;
  const ChatPage({
    super.key,
    required this.currentUser,
    required this.changePage,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin<ChatPage> {
  int _chatPage = 1;
  bool _chatsearchprocess = false;
  bool _isFirstFetch = true;
  List<Chat> _filteredItems = [];
  final TextEditingController _chatcontroller = TextEditingController();

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
      _filteredItems = widget.currentUser.chatlist!.where((item) {
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

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      getchat(fetchRestart: true);
    });
  }

  Future<void> getchat({bool fetchRestart = false}) async {
    if (_chatsearchprocess) {
      return;
    }

    if (fetchRestart) {
      _chatPage = 1;
      widget.currentUser.chatlist = [];
    }

    if (_chatPage == 1 && !fetchRestart) {
      if (widget.currentUser.chatlist != null) {
        _filteredItems = widget.currentUser.chatlist!;

        int pageCount =
            (widget.currentUser.widgetStoriescard!.length / 30).ceil();
        log(pageCount.toString());

        _chatPage = pageCount;
        _chatPage++;
      } else {
        widget.currentUser.chatlist = [];
      }
    }

    _chatsearchprocess = true;
    FunctionService f = FunctionService(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.getchats(_chatPage);
    if (response["durum"] == 0) {
      _chatsearchprocess = false;
      _isFirstFetch = false;

      //10 saniye sonra Tekrar çekmeyi dene
      await Future.delayed(const Duration(seconds: 10));
      await getchat();
      return;
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
      bool notification = false;
      if (response["icerik"][i]["bildirim"] == 1) {
        notification = true;
      }

      widget.currentUser.chatlist!.add(
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
                bigURL: response["icerik"][i]["chatImage"]["media_bigURL"],
                normalURL: response["icerik"][i]["chatImage"]["media_URL"],
                minURL: response["icerik"][i]["chatImage"]["media_minURL"],
              ),
            ),
          ),
          lastmessage: ChatMessage(
            user: User(userID: 1, avatar: null, displayName: ""),
            messageContext: sonmesaj,
            messageID: 1,
            isMe: response["icerik"][i]["kullid"] == widget.currentUser.userID
                ? true
                : false,
          ),
          chatType: response["icerik"][i]["sohbetturu"],
          chatNotification: notification,
        ),
      );
      setstatefunction();
    }

    _filteredItems = widget.currentUser.chatlist!;

    setstatefunction();

    _chatsearchprocess = false;
    _isFirstFetch = false;
    _chatPage++;
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
                    return _filteredItems[index]
                        .listtilechat(context, currentUser: widget.currentUser);
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "NewChatButton${widget.currentUser.userID}",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatNewPage(
                currentUser: widget.currentUser,
              ),
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
