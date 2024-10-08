import 'package:ARMOYU/app/data/models/ARMOYU/country.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/job.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/province.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/role.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/station.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/team.dart';
import 'package:ARMOYU/app/widgets/text.dart';
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
  bool? ismyFriend;

  // //Arkadaşlarım
  List<User>? myFriends = [];
  List<User>? mycloseFriends = [];

  // //ARAÇ GEREÇ
  List<Chat>? chatlist = [];

  // //Gruplarım & Okullarım & İşyerlerim
  List<Group>? myGroups = [];
  List<School>? mySchools = [];
  List<Station>? myStations = [];

  //Sosyal KISIM
  List<Post>? widgetPosts;
  List<StoryList>? widgetStoriescard;

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
    this.ismyFriend,
    this.phoneNumber,
    this.birthdayDate,
    this.myFriends,
    this.chatlist,
    this.mycloseFriends,
    this.myGroups,
    this.mySchools,
    this.myStations,
    this.widgetPosts,
    this.widgetStoriescard,
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
      role: json['role'] == null
          ? null
          : Role(
              roleID: json['role']['roleID'],
              color: json['role']['color'],
              name: json['role']['name'],
            ),
      friendsCount: json['friendscount'],
      postsCount: json['postscount'],
      awardsCount: json['awardscount'],
      avatar: json['avatar'] == null
          ? null
          : Media(
              mediaID: json['avatar']['media_ID'],
              mediaURL: MediaURL(
                bigURL: json['avatar']['media_bigURL'],
                normalURL: json['avatar']['media_normalURL'],
                minURL: json['avatar']['media_minURL'],
              ),
            ),
      banner: json['banner'] == null
          ? null
          : Media(
              mediaID: json['banner']['media_ID'],
              mediaURL: MediaURL(
                bigURL: json['banner']['media_bigURL'],
                normalURL: json['banner']['media_normalURL'],
                minURL: json['banner']['media_minURL'],
              ),
            ),
      myFriends: json['myfriends'] != null
          ? List<User>.from(
              json['myfriends'].map((friendJson) => User.fromJson(friendJson)))
          : null,
      chatlist: json['chatlist'] != null
          ? List<Chat>.from(
              json['chatlist'].map((friendJson) => Chat.fromJson(friendJson)))
          : null,
      myGroups: json['myGroups'] != null
          ? List<Group>.from(
              json['myGroups'].map((friendJson) => Group.fromJson(friendJson)))
          : null,
      lastlogin: json['lastlogin'],
      lastloginv2: json['lastloginv2'],
      widgetPosts: json['widgetposts'] != null
          ? List<Post>.from(
              json['widgetposts'].map((postJson) => Post.fromJson(postJson)))
          : null,
      widgetStoriescard: json['widgetstoriescard'] != null
          ? List<StoryList>.from(json['widgetstoriescard']
              .map((storylistJson) => StoryList.fromJson(storylistJson)))
          : null,
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
      'role': role != null
          ? {
              'roleID': role!.roleID,
              'color': role!.color,
              'name': role!.name,
            }
          : null,
      'friendscount': friendsCount,
      'postscount': postsCount,
      'awardscount': awardsCount,
      'avatar': avatar != null
          ? {
              'media_ID': avatar!.mediaID,
              'media_bigURL': avatar!.mediaURL.bigURL,
              'media_normalURL': avatar!.mediaURL.normalURL,
              'media_minURL': avatar!.mediaURL.minURL,
            }
          : null,
      'banner': banner != null
          ? {
              'media_ID': banner!.mediaID,
              'media_bigURL': banner!.mediaURL.bigURL,
              'media_normalURL': banner!.mediaURL.normalURL,
              'media_minURL': banner!.mediaURL.minURL,
            }
          : null,
      'myfriends': myFriends?.map((friend) => friend.toJson()).toList(),
      'chatlist': chatlist?.map((chat) => chat.toJson()).toList(),
      'myGroups': myGroups?.map((myGroups) => myGroups.toJson()).toList(),
      'lastlogin': lastlogin,
      'lastloginv2': lastloginv2,
      'widgetposts': widgetPosts?.map((posts) => posts.toJson()).toList(),
      'widgetstoriescard':
          widgetStoriescard?.map((stories) => stories.toJson()).toList(),
    };
  }

  void updateUser({required User targetUser}) {
    if (userID != null) targetUser.userID = userID;
    if (userName != null) targetUser.userName = userName;
    if (firstName != null) {
      targetUser.firstName = firstName;
    }
    if (lastName != null) targetUser.lastName = lastName;
    if (password != null) targetUser.password = password;
    if (displayName != null) {
      targetUser.displayName = displayName;
    }
    if (avatar != null) targetUser.avatar = avatar;
    if (banner != null) targetUser.banner = banner;
    if (userMail != null) targetUser.userMail = userMail;
    if (country != null) targetUser.country = country;
    if (province != null) targetUser.province = province;
    if (registerDate != null) {
      targetUser.registerDate = registerDate;
    }
    if (job != null) targetUser.job = job;
    if (role != null) targetUser.role = role;
    if (aboutme != null) targetUser.aboutme = aboutme;
    if (burc != null) targetUser.burc = burc;
    if (invitecode != null) {
      targetUser.invitecode = invitecode;
    }
    if (lastlogin != null) {
      targetUser.lastlogin = lastlogin;
    }
    if (lastloginv2 != null) {
      targetUser.lastloginv2 = lastloginv2;
    }
    if (lastfaillogin != null) {
      targetUser.lastfaillogin = lastfaillogin;
    }
    if (level != null) targetUser.level = level;
    if (levelColor != null) {
      targetUser.levelColor = levelColor;
    }
    if (xp != null) targetUser.xp = xp;
    if (friendsCount != null) {
      targetUser.friendsCount = friendsCount;
    }
    if (postsCount != null) {
      targetUser.postsCount = postsCount;
    }
    if (awardsCount != null) {
      targetUser.awardsCount = awardsCount;
    }
    if (phoneNumber != null) {
      targetUser.phoneNumber = phoneNumber;
    }
    if (birthdayDate != null) {
      targetUser.birthdayDate = birthdayDate;
    }
    if (favTeam != null) targetUser.favTeam = favTeam;
    if (status != null) targetUser.status = status;
    if (ismyFriend != null) {
      targetUser.ismyFriend = ismyFriend;
    }
    if (myFriends != null) {
      targetUser.myFriends = myFriends;
    }

    if (chatlist != null) {
      targetUser.chatlist = chatlist;
    }
    if (mycloseFriends != null) {
      targetUser.mycloseFriends = mycloseFriends;
    }
    if (myGroups != null) targetUser.myGroups = myGroups;
    if (mySchools != null) {
      targetUser.mySchools = mySchools;
    }
    if (myStations != null) {
      targetUser.myStations = myStations;
    }

    if (widgetPosts != null) {
      targetUser.widgetPosts = widgetPosts;
    }

    if (widgetPosts != null) {
      targetUser.widgetPosts = widgetPosts;
    }

    if (widgetStoriescard != null) {
      targetUser.widgetStoriescard = widgetStoriescard;
    }
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
