import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'dart:isolate';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Chat/chat_message.dart';
import 'package:ARMOYU/Screens/Chat/chatcall_page.dart';
import 'package:ARMOYU/Services/Socket/socket.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';

class ChatDetailPage extends StatefulWidget {
  final bool appbar;
  final int userID;
  final String useravatar;
  final String userdisplayname;
  final String? lastonlinetime;
  final List<ChatMessage> chats;

  const ChatDetailPage({
    super.key,
    required this.appbar,
    required this.userID,
    required this.useravatar,
    required this.userdisplayname,
    this.lastonlinetime,
    required this.chats,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPage();
}

final TextEditingController _messageController = TextEditingController();

final ScrollController _scrollController = ScrollController();
List<ChatMessage> chatList = [];

class _ChatDetailPage extends State<ChatDetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

/////////
  Isolate? isolateListen;
  ReceivePort? receiveportListen;

  Isolate? isolateSend;
  ReceivePort? receiveportSend;

  bool isUserOnline = false;

  @override
  void initState() {
    super.initState();

    getchat().then((_) {
      isolatestart();
    });
  }

  @override
  void dispose() {
    super.dispose();

    try {
      receiveportListen!.close();
      isolateListen!.kill();

      receiveportSend!.close();
      isolateSend!.kill();
    } catch (e) {
      log(e.toString());
    }
  }

  void isolatestart() async {
    receiveportListen = ReceivePort();

    receiveportSend = ReceivePort();

    isolateListen = await Isolate.spawn(socketListenMessage, [
      receiveportListen!.sendPort,
      ARMOYU.Appuser.userID.toString(),
      widget.userID.toString()
    ]);

    receiveportListen!.listen((message) async {
      try {
        var jsonData = jsonDecode(utf8.decode(message.codeUnits));

        Map<String, dynamic> responseData = jsonData;

        if (responseData["sender_id"].toString() ==
            ARMOYU.Appuser.userID.toString()) {
          return;
        }

        if (responseData["receiver_id"].toString() ==
            ARMOYU.Appuser.userID.toString()) {
          message = responseData["message"].toString();
        }

        setState(() {
          chatList.add(
            ChatMessage(
              avatar: widget.useravatar,
              displayName: widget.userdisplayname,
              isMe: false,
              messageContext: message,
              messageID: 0,
              userID: widget.userID,
            ),
          );
        });

        try {
          await Future.delayed(const Duration(milliseconds: 20));
          await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 20),
            curve: Curves.easeOut,
          );
        } catch (e) {
          log(e.toString());
        }
        log(message);
      } catch (e) {
        log("json hatası");
      }
    });

    ARMOYU_Socket socket2 = ARMOYU_Socket(
        ARMOYU.Appuser.userID.toString(),
        ARMOYU.Appuser.userName!,
        ARMOYU.Appuser.password!,
        widget.userID.toString());

    receiveportSend!.listen(
      (message) {
        log("Send: $message");
        if (message != "") {
          socket2.sendMessage(receiveportListen!.sendPort, message);
        }
      },
    );
  }

  static Future<void> socketListenMessage(List<dynamic> arguments) async {
    final SendPort sendPort = arguments.first;
    final String senderID = arguments[1];
    final String receiverID = arguments.last;
    log("$senderID >>>> $receiverID");

    try {
      ARMOYU_Socket socket2 = ARMOYU_Socket(senderID, ARMOYU.Appuser.userName!,
          ARMOYU.Appuser.password!, receiverID);
      socket2.receiveMessages(sendPort);
    } catch (e) {
      log(e.toString());
    }
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

    chatList.clear();

    for (int i = 0; i < dynamicItemCount; i++) {
      try {
        setState(() {
          if (response["icerik"][i]["sohbetkim"] == "ben") {
            ismee = true;
          } else {
            ismee = false;
          }

          chatList.add(
            ChatMessage(
              avatar: response["icerik"][i]["avatar"],
              displayName: response["icerik"][i]["avatar"],
              isMe: ismee,
              messageContext: response["icerik"][i]["mesajicerik"],
              messageID: 0,
              userID: widget.userID,
            ),
          );
        });
      } catch (e) {
        log("Sohbet getirilemedi!");
      }

      try {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      } catch (e) {
        log(e.toString());
      }
    }

    // Biraz bekleme süresi ekleyin,
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: widget.appbar
            ? AppBar(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userdisplayname,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.lastonlinetime!.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                widget.lastonlinetime!.toString() == "Çevrimiçi"
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                leading: Builder(
                  builder: (BuildContext context) {
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  userID: widget.userID,
                                  appbar: true,
                                ),
                              ),
                            );
                          },
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
                    icon: const Icon(Icons.call),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatCallPage(
                            userID: widget.userID,
                            useravatar: widget.useravatar,
                            userdisplayname: widget.userdisplayname,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      getchat();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : null,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  'https://i.pinimg.com/originals/f7/ae/e8/f7aee8753832af613b63e51d5f07011a.jpg'), // Resim dosyasının yolu
              fit: BoxFit.fill,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return chatList[index].messageBumble(context);
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5),
                      height: 50,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: 'Mesaj yaz',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_messageController.text == "") {
                          return;
                        }
                        String message = _messageController.text;
                        _messageController.text = "";
                        setState(() {
                          chatList.add(
                            ChatMessage(
                              avatar: ARMOYU.Appuser.avatar!.mediaURL.minURL,
                              displayName: ARMOYU.Appuser.displayName!,
                              isMe: true,
                              messageContext: message,
                              messageID: 0,
                              userID: ARMOYU.Appuser.userID!,
                            ),
                          );
                          try {
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent +
                                    100,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            });
                          } catch (e) {
                            log(e.toString());
                          }
                        });

                        FunctionService f = FunctionService();
                        Map<String, dynamic> response = await f.sendchatmessage(
                            widget.userID, message, "ozel");
                        if (response["durum"] == 0) {
                          log(response["aciklama"]);
                          return;
                        }

                        receiveportSend!.sendPort.send(message);
                      },
                      child: const Icon(
                        Icons.send,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String avatar;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(avatar),
              ),
            ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 70),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  isMe ? Colors.blue : const Color.fromARGB(255, 212, 78, 69),
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.white,
                        ),
                      ),
                    ),
                    const Visibility(
                      child: Positioned(
                        bottom: -3,
                        right: 0,
                        child: Icon(
                          Icons.done_all,
                          color: Color.fromRGBO(116, 243, 20, 1),
                          size: 14,
                        ), // Okundu işareti
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
