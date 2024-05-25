import 'package:ARMOYU/Models/ARMOYU/country.dart';
import 'package:ARMOYU/Models/ARMOYU/job.dart';
import 'package:ARMOYU/Models/ARMOYU/province.dart';
import 'package:ARMOYU/Models/ARMOYU/role.dart';
import 'package:ARMOYU/Models/group.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/school.dart';
import 'package:ARMOYU/Models/station.dart';
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

  bool? status;

  // //Arkadaşlarım
  List<User>? myFriends = [];
  List<User>? mycloseFriends = [];

  // //Gruplarım & Okullarım & İşyerlerim
  List<Group>? myGroups = [];
  List<School>? mySchools = [];
  List<Station>? myStations = [];

  User({
    this.userID,
    this.userName,
    this.password,
    this.firstName,
    this.lastName,
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
    this.status,
    this.phoneNumber,
    this.birthdayDate,
    this.myFriends,
    this.mycloseFriends,
    this.myGroups,
    this.mySchools,
    this.myStations,
  });

  // JSON'dan User nesnesine dönüşüm
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      userName: json['username'],
      password: json['password'],
      displayName: json['displayname'],
      aboutme: json['aboutme'],
      level: json['level'],
      xp: json['xp'],
      levelColor: json['levelcolor'],
      userMail: json['usermail'],
      friendsCount: json['friendscount'],
      postsCount: json['postscount'],
      awardsCount: json['awardscount'],
      avatar: Media(
        mediaID: json['avatar']['media_ID'],
        mediaURL: MediaURL(
          bigURL: json['avatar']['media_bigURL'],
          normalURL: json['avatar']['media_normalURL'],
          minURL: json['avatar']['media_minURL'],
        ),
      ),
      banner: Media(
        mediaID: json['banner']['media_ID'],
        mediaURL: MediaURL(
          bigURL: json['banner']['media_bigURL'],
          normalURL: json['banner']['media_normalURL'],
          minURL: json['banner']['media_minURL'],
        ),
      ),
    );
  }

  // User nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': userName,
      'password': password,
      'displayname': displayName,
      'aboutme': aboutme,
      'level': level,
      'xp': xp,
      'levelcolor': levelColor,
      'usermail': userMail,
      'friendscount': friendsCount,
      'postscount': postsCount,
      'awardscount': awardsCount,
      'avatar': {
        'media_ID': avatar!.mediaID,
        'media_bigURL': avatar!.mediaURL.bigURL,
        'media_normalURL': avatar!.mediaURL.normalURL,
        'media_minURL': avatar!.mediaURL.minURL,
      },
      'banner': {
        'media_ID': banner!.mediaID,
        'media_bigURL': banner!.mediaURL.bigURL,
        'media_normalURL': banner!.mediaURL.normalURL,
        'media_minURL': banner!.mediaURL.minURL,
      },
    };
  }

  Widget storyViewUserList({bool isLiked = false}) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: CachedNetworkImageProvider(avatar!.mediaURL.minURL),
      ),
      title: CustomText.costum1(displayName!, weight: FontWeight.bold),
      trailing: isLiked
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : null,
      onTap: () {},
    );
  }
}
