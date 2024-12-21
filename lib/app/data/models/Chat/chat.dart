import 'package:ARMOYU/app/data/models/Chat/chat_message.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chat {
  int? chatID;
  User user;
  Rx<ChatMessage>? lastmessage;
  RxList<ChatMessage>? messages;
  String? chatType;
  Rx<bool> chatNotification;

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
      'lastmessage': lastmessage?.value.toJson(),
      'messages': messages?.map((message) => message.toJson()).toList(),
      'chatType': chatType,
      'chatNotification': chatNotification.value,
    };
  }

  // JSON'dan Chat nesnesine dönüşüm
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatID: json['chatID'],
      user: User.fromJson(json['user']),
      lastmessage: json['lastmessage'] == null
          ? null
          : ChatMessage.fromJson(json['lastmessage']).obs,
      messages: json['messages'] == null
          ? null
          : (json['messages'] as List<dynamic>?)
              ?.map((member) => ChatMessage.fromJson(member))
              .toList()
              .obs,
      chatType: json['chatType'],
      chatNotification: (json['chatNotification'] as bool).obs,
    );
  }

  Widget listtilechat(context, {required VoidCallback onDelete}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundImage: CachedNetworkImageProvider(
          user.avatar!.mediaURL.minURL.value,
        ),
        radius: 28,
      ),
      tileColor: chatNotification.value ? Colors.red.shade900 : null,
      title: CustomText.costum1(user.displayName!.value),
      subtitle: lastmessage == null
          ? const Text("")
          : Row(
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        if (lastmessage!.value.isMe)
                          const WidgetSpan(
                            child: Icon(
                              Icons.done_all,
                              color: Color.fromRGBO(116, 243, 20, 1),
                              size: 14,
                            ),
                          ),
                        if (lastmessage!.value.isMe)
                          const WidgetSpan(
                            child: SizedBox(width: 5),
                          ),
                        TextSpan(
                          text: lastmessage!.value.messageContext,
                          style: TextStyle(
                            color: Get.theme.primaryColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      trailing: chatType == "ozel"
          ? const Icon(Icons.person)
          : const Icon(Icons.people_alt),
      onTap: () {
        chatNotification.value = false;
        Get.toNamed(
          "/chat/detail",
          arguments: {"chat": this},
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Sil'),
                      onTap: () {
                        Navigator.pop(context);
                        onDelete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Öğe silindi.'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
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
