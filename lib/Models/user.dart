import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class User {
  int? userID = -1;
  String? userName = "0";
  String? firstName = "";
  String? lastName = "";
  String? password = "0";
  String? displayName = "";
  Media? avatar;
  Media? banner;

  String? userMail = "";

  String? country = "";
  String? province = "";
  String? registerDate = "";
  String? job = "";
  String? role = "";
  String? rolecolor = "";

  String? aboutme = "";
  String? burc = "";
  String? invitecode = "";

  int? level = 0;

  int? friendsCount = 0;
  int? postsCount = 0;
  int? awardsCount = 0;

  Team? favTeam;

  User({
    this.userID,
    this.userName,
    this.firstName,
    this.lastName,
    this.password,
    this.displayName,
    this.avatar,
    this.banner,
    this.userMail,
    this.country,
    this.province,
    this.registerDate,
    this.job,
    this.role,
    this.rolecolor,
    this.aboutme,
    this.burc,
    this.invitecode,
    this.level,
    this.friendsCount,
    this.postsCount,
    this.awardsCount,
    this.favTeam,
  });

  Widget storyViewUserList() {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(avatar!.mediaURL.minURL),
      ),
      title: CustomText.costum1(displayName!, weight: FontWeight.bold),
      trailing: const Icon(Icons.message),
      onTap: () {},
    );
  }
}
