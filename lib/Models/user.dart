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

  Widget storyViewUserList(User user) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(user.avatar),
      ),
      title: Text(user.displayname),
    );
  }
}
