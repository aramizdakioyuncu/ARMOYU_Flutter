import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Chat/chat_message.dart';
import 'package:ARMOYU/Screens/Chat/chatdetail_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Chat {
  final int chatID;
  final String displayName;
  final String avatar;
  final int userID;
  final String? lastonlinetime;
  final ChatMessage? lastmessage;
  final List<ChatMessage>? messages;
  final String chatType;
  final bool chatNotification;

  Chat({
    required this.chatID,
    required this.displayName,
    required this.avatar,
    required this.userID,
    this.lastonlinetime,
    this.lastmessage,
    this.messages,
    required this.chatType,
    required this.chatNotification,
  });

  Widget listtilechat(context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          leading: CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(avatar),
          ),
          tileColor:
              chatNotification ? Colors.red.shade900 : ARMOYU.appbarColor,
          title: CustomText.costum1(displayName),
          subtitle:
              lastmessage == null ? null : Text(lastmessage!.messageContext),
          trailing: chatType == "ozel"
              ? const Icon(Icons.person)
              : const Icon(Icons.people_alt),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (pagecontext) => ChatDetailPage(
                  userID: userID,
                  appbar: true,
                  useravatar: avatar,
                  userdisplayname: displayName,
                  lastonlinetime: lastonlinetime,
                  chats: const [],
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
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(avatar),
      ),
      title: CustomText.costum1(displayName),
      subtitle: lastmessage == null ? null : Text(lastmessage!.messageContext),
      trailing: Text(lastonlinetime.toString()),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (pagecontext) => ChatDetailPage(
              userID: userID,
              appbar: true,
              useravatar: avatar,
              userdisplayname: displayName,
              chats: const [],
            ),
          ),
        );
      },
    );
  }
}
