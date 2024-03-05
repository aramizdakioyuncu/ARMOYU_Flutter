import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class User {
  String username;
  String displayname;
  String avatar;

  User({
    required this.username,
    required this.displayname,
    required this.avatar,
  });

  Widget storyViewUserList() {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(avatar),
      ),
      title: CustomText().Costum1(displayname, weight: FontWeight.bold),
      trailing: const Icon(Icons.message),
      onTap: () {},
    );
  }
}
