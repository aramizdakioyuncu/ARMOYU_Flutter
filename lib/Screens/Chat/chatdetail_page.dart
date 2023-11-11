// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, must_be_immutable, override_on_non_overriding_member, library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, must_call_super

import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/Services/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Services/functions_service.dart';

class ChatDetailPage extends StatefulWidget {
  final bool appbar;
  final int userID; // Zorunlu olarak alınacak veri
  final String useravatar; // Zorunlu olarak alınacak veri
  final String userdisplayname; // Zorunlu olarak alınacak veri

  ChatDetailPage({
    required this.appbar,
    required this.userID,
    required this.useravatar,
    required this.userdisplayname,
  });

  @override
  _ChatDetailPage createState() => _ChatDetailPage();
}

final ScrollController _scrollController = ScrollController();

class _ChatDetailPage extends State<ChatDetailPage>
    with AutomaticKeepAliveClientMixin<ChatDetailPage> {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _messageController = TextEditingController();
  List<Widget> Widget_search = [];
  bool postsearchprocess = false;

  @override
  void initState() {
    super.initState();
    Widget_search.clear();
    getchat();
  }

  Future<void> getchat() async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getdeailchats(widget.userID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    int dynamicItemCount = response["icerik"].length;
    if (dynamicItemCount == 0) {
      return;
    }
    bool ismee = true;

    Widget_search.clear();

    for (int i = 0; i < dynamicItemCount; i++) {
      try {
        setState(() {
          if (response["icerik"][i]["sohbetkim"] == "ben") {
            ismee = true;
          } else {
            ismee = false;
          }

          Widget_search.add(MessageBubble(
            avatar: response["icerik"][i]["avatar"],
            message: response["icerik"][i]["mesajicerik"],
            isMe: ismee,
          ));
        });

        if (i == dynamicItemCount - 1) {
          try {
            await Future.delayed(Duration(milliseconds: 20));
            await _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 20),
              curve: Curves.easeOut,
            );
          } catch (e) {}
        }
      } catch (e) {}
    }

    // Biraz bekleme süresi ekleyin,
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: widget.appbar
          ? AppBar(
              title: Text(widget.userdisplayname),
              leading: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      // İçerik eklemek istediğiniz işlemleri burada yapabilirsiniz.
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: CachedNetworkImage(
                          imageUrl: widget.useravatar,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    getchat();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          ChatInterface(messages: Widget_search),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  height: 50,
                  child: Center(
                    // TextField'ı Container'ın ortasına yerleştirmek için Center kullanın
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Mesaj yaz',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_messageController.text == "") {
                      return;
                    }
                    setState(() {
                      Widget_search.add(MessageBubble(
                        avatar: User.avatar,
                        message: _messageController.text,
                        isMe: true,
                      ));
                    });
                    FunctionService f = FunctionService();
                    Map<String, dynamic> response = await f.sendchatmessage(
                        widget.userID, _messageController.text, "ozel");
                    if (response["durum"] == 0) {
                      log(response["aciklama"]);
                      return;
                    }

                    _messageController.text = "";
                    try {
                      await Future.delayed(Duration(milliseconds: 20));
                      await _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 20),
                        curve: Curves.easeOut,
                      );
                    } catch (e) {}
                  },
                  child: Icon(
                    Icons.send,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatInterface extends StatelessWidget {
  final List<Widget> messages;

  ChatInterface({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return messages[index];
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String avatar;

  MessageBubble(
      {required this.message, required this.isMe, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              padding: EdgeInsets.only(right: 5),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(avatar),
              ),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 50),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
