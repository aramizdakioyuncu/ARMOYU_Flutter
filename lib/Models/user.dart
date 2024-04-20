import 'package:ARMOYU/Models/ARMOYU/country.dart';
import 'package:ARMOYU/Models/ARMOYU/job.dart';
import 'package:ARMOYU/Models/ARMOYU/province.dart';
import 'package:ARMOYU/Models/ARMOYU/role.dart';
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

  Country? country;
  Province? province;
  String? registerDate = "";
  Job? job;
  Role? role;

  String? aboutme = "";
  String? burc = "";
  String? invitecode = "";
  String? lastlogin = "";
  String? lastloginv2 = "";
  String? lastfaillogin = "";

  int? level = 0;
  String? levelColor;
  String? xp;

  int? friendsCount = 0;
  int? postsCount = 0;
  int? awardsCount = 0;

  String? phoneNumber;
  String? birthdayDate;
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
    this.aboutme,
    this.burc,
    this.invitecode,
    this.lastlogin,
    this.lastloginv2,
    this.lastfaillogin,
    this.level,
    this.levelColor,
    this.xp,
    this.friendsCount,
    this.postsCount,
    this.awardsCount,
    this.favTeam,
    this.phoneNumber,
    this.birthdayDate,
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
