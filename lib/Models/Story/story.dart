import 'package:ARMOYU/Models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Story {
  int storyID;
  int ownerID;
  String ownerusername;
  String owneravatar;
  String time;
  String media;

  Story({
    required this.storyID,
    required this.ownerID,
    required this.ownerusername,
    required this.owneravatar,
    required this.time,
    required this.media,
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
