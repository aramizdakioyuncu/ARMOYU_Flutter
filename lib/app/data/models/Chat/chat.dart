import 'package:ARMOYU/app/data/models/Chat/chat_message.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Widget listtilechat(context, {required UserAccounts currentUserAccounts}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundImage: CachedNetworkImageProvider(
          user.avatar!.mediaURL.minURL.value,
        ),
      ),
      tileColor: chatNotification ? Colors.red.shade900 : null,
      title: CustomText.costum1(user.displayName!),
      subtitle: lastmessage == null
          ? const Text("")
          : Text(lastmessage!.messageContext),
      trailing: chatType == "ozel"
          ? const Icon(Icons.person)
          : const Icon(Icons.people_alt),
      onTap: () {
        Get.toNamed(
          "/chat/detail",
          arguments: {"chat": this, "CurrentUserAccounts": currentUserAccounts},
        );
      },
    );
  }

  Widget profilesendMessage(context,
      {required UserAccounts currentUserAccounts}) {
    Future<void> sendmessage() async {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ChatDetailPage(
      //       chat: this,
      //       currentUserAccounts: currentUserAccounts,
      //     ),
      //   ),
      // );

      Get.toNamed("/chat/detail", arguments: {
        "chat": this,
        "CurrentUserAccounts": currentUserAccounts,
      });
    }

    return CustomButtons.friendbuttons(
        "Mesaj Gönder", sendmessage, Colors.blue);
  }
}
