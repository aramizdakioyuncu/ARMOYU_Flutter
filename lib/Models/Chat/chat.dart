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

  Chat({
    required this.chatID,
    required this.displayName,
    required this.avatar,
    required this.userID,
    this.lastonlinetime,
    this.lastmessage,
    this.messages,
    required this.chatType,
  });

  Widget listtilechat(context) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(avatar),
      ),
      title: CustomText.costum1(displayName),
      subtitle: lastmessage == null ? null : Text(lastmessage!.messageContext),
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
              chats: const [],
            ),
          ),
        );
      },
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
