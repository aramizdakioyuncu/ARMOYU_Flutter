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
  final ChatMessage? lastmessage;
  List<ChatMessage> messages = [];
  final String? chatType;
  final bool chatNotification;

  Chat({
    this.chatID,
    required this.user,
    this.lastmessage,
    this.chatType,
    required this.chatNotification,
  });

  Widget listtilechat(context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          leading: CircleAvatar(
            foregroundImage:
                CachedNetworkImageProvider(user.avatar!.mediaURL.minURL),
          ),
          tileColor:
              chatNotification ? Colors.red.shade900 : ARMOYU.appbarColor,
          title: CustomText.costum1(user.displayName!),
          subtitle:
              lastmessage == null ? null : Text(lastmessage!.messageContext),
          trailing: chatType == "ozel"
              ? const Icon(Icons.person)
              : const Icon(Icons.people_alt),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (pagecontext) => ChatDetailPage(
                  chat: this,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 1)
      ],
    );
  }

  Widget listtilenewchat(context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            foregroundImage:
                CachedNetworkImageProvider(user.avatar!.mediaURL.minURL),
          ),
          title: CustomText.costum1(user.displayName!),
          tileColor: ARMOYU.appbarColor,
          subtitle:
              lastmessage == null ? null : Text(lastmessage!.messageContext),
          trailing: Text(user.lastloginv2.toString()),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (pagecontext) => ChatDetailPage(
                  chat: this,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 1)
      ],
    );
  }

  Widget profilesendMessage(context) {
    Future<void> sendmessage() async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(
            chat: this,
          ),
        ),
      );
    }

    return CustomButtons.friendbuttons(
        "Mesaj Gönder", sendmessage, Colors.blue);
  }
}
