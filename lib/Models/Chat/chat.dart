import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Chat/chat_message.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Chat/chatdetail_page.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Chat {
  final int? chatID;
  final User user;
  ChatMessage? lastmessage;
  List<ChatMessage>? messages;
  final String? chatType;
  bool chatNotification;

  Chat({
    this.chatID,
    required this.user,
    this.lastmessage,
    this.messages,
    this.chatType,
    required this.chatNotification,
  });

  // Chat nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'user': user.toJson(),
      'lastmessage': lastmessage?.toJson(),
      'messages': messages?.map((message) => message.toJson()).toList(),
      'chatType': chatType,
      'chatNotification': chatNotification,
    };
  }

  // JSON'dan Chat nesnesine dönüşüm
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatID: json['chatID'],
      user: User.fromJson(json['user']),
      lastmessage: json['lastmessage'] != null
          ? ChatMessage.fromJson(json['lastmessage'])
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List<dynamic>)
              .map((message) => ChatMessage.fromJson(message))
              .toList()
          : null,
      chatType: json['chatType'],
      chatNotification: json['chatNotification'],
    );
  }

  Widget listtilechat(context, {required User currentUser}) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(
              user.avatar!.mediaURL.minURL,
            ),
          ),
          tileColor:
              chatNotification ? Colors.red.shade900 : ARMOYU.appbarColor,
          title: CustomText.costum1(user.displayName!),
          subtitle: lastmessage == null
              ? const Text("")
              : Text(lastmessage!.messageContext),
          trailing: chatType == "ozel"
              ? const Icon(Icons.person)
              : const Icon(Icons.people_alt),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (pagecontext) => ChatDetailPage(
                  chat: this,
                  currentUser: currentUser,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 1)
      ],
    );
  }

  Widget profilesendMessage(context, {required User currentUser}) {
    Future<void> sendmessage() async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(
            chat: this,
            currentUser: currentUser,
          ),
        ),
      );
    }

    return CustomButtons.friendbuttons(
        "Mesaj Gönder", sendmessage, Colors.blue);
  }
}
