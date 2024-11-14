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
import 'package:get/get.dart';

class User {
  int? userID = -1;
  Rx<String>? userName = "0".obs;
  Rx<String>? firstName = "".obs;
  Rx<String>? lastName = "".obs;
  Rx<String>? password = "0".obs;
  Rx<String>? displayName = "".obs;
  Media? avatar;
  Media? banner;

  Rx<String>? userMail = "".obs;

  Rx<Country>? country;
  Rx<Province>? province;
  String? registerDate = "";
  Job? job;
  Role? role;

  Rx<String>? aboutme = "".obs;
  Rx<String>? burc = "".obs;
  Rx<String>? invitecode = "".obs;
  Rx<String>? lastlogin = "".obs;
  Rx<String>? lastloginv2 = "".obs;
  Rx<String>? lastfaillogin = "".obs;

  Rx<int>? level = 0.obs;
  Rx<String>? levelColor;
  Rx<String>? xp;

  int? friendsCount = 0;

  int? postsCount = 0;
  int? awardsCount = 0;

  Rxn<String>? phoneNumber;
  Rxn<String>? birthdayDate;
  Team? favTeam;

  bool? status;
  Rx<bool>? ismyFriend;

  // //Arkadaşlarım

  RxList<User>? myFriends;
  RxList<User>? mycloseFriends;

  // //ARAÇ GEREÇ
  RxList<Chat>? chatlist;

  // //Gruplarım & Okullarım & İşyerlerim
  List<Group>? myGroups = [];
  List<School>? mySchools = [];
  List<Station>? myStations = [];

  //Sosyal KISIM
  RxList<Post>? widgetPosts;
  RxList<StoryList>? widgetStoriescard;

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
      userName:
          json['username'] == null ? null : (json['username'] as String).obs,
      firstName:
          json['firstname'] == null ? null : (json['firstname'] as String).obs,
      lastName:
          json['lastname'] == null ? null : (json['lastname'] as String).obs,
      password:
          json['password'] == null ? null : (json['password'] as String).obs,
      displayName: json['displayname'] == null
          ? null
          : (json['displayname'] as String).obs,
      aboutme: json['aboutme'] == null ? null : (json['aboutme'] as String).obs,
      level: json['level'] == null ? null : (json['level'] as int).obs,
      levelColor: json['levelcolor'] == null
          ? null
          : (json['levelcolor'] as String).obs,
      xp: json['xp'] == null ? null : (json['xp'] as String).obs,
      phoneNumber: Rxn<String>(json['phoneNumber']),
      birthdayDate: Rxn<String>(json['birthdayDate']),
      userMail:
          json['usermail'] == null ? null : (json['usermail'] as String).obs,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country']).obs,
      province: json['province'] == null
          ? null
          : Province.fromJson(json['province']).obs,
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
                bigURL: Rx<String>(json['avatar']['media_bigURL']),
                normalURL: Rx<String>(json['avatar']['media_normalURL']),
                minURL: Rx<String>(json['avatar']['media_minURL']),
              ),
            ),
      banner: json['banner'] == null
          ? null
          : Media(
              mediaID: json['banner']['media_ID'],
              mediaURL: MediaURL(
                bigURL: Rx<String>(json['banner']['media_bigURL']),
                normalURL: Rx<String>(json['banner']['media_normalURL']),
                minURL: Rx<String>(json['banner']['media_minURL']),
              ),
            ),
      myFriends: json['myfriends'] == null
          ? null
          : (json['myfriends'] as List<dynamic>?)
              ?.map((friendJson) => User.fromJson(friendJson))
              .toList()
              .obs,
      chatlist: json['chatlist'] == null
          ? null
          : (json['chatlist'] as List<dynamic>?)
              ?.map((chatlist) => Chat.fromJson(chatlist))
              .toList()
              .obs,
      myGroups: json['myGroups'] == null
          ? null
          : (json['myGroups'] as List<dynamic>?)
              ?.map((myGroups) => Group.fromJson(myGroups))
              .toList()
              .obs,
      lastlogin:
          json['lastlogin'] == null ? null : (json['lastlogin'] as String).obs,
      lastloginv2: json['lastloginv2'] == null
          ? null
          : (json['lastloginv2'] as String).obs,
      widgetPosts: json['widgetposts'] == null
          ? null
          : (json['widgetposts'] as List<dynamic>?)
              ?.map((widgetpost) => Post.fromJson(widgetpost))
              .toList()
              .obs,
      widgetStoriescard: json['widgetstoriescard'] == null
          ? null
          : (json['widgetstoriescard'] as List<dynamic>?)
              ?.map((storylistJson) => StoryList.fromJson(storylistJson))
              .toList()
              .obs,
      ismyFriend:
          json['ismyFriend'] == null ? null : (json['ismyFriend'] as bool).obs,
    );
  }

  // User nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': userName?.value,
      'firstname': firstName?.value,
      'lastname': lastName?.value,
      'password': password?.value,
      'displayname': displayName?.value,
      'aboutme': aboutme?.value,
      'level': level?.value,
      'xp': xp?.value,
      'phoneNumber': phoneNumber?.value,
      'birthdayDate': birthdayDate?.value,
      'levelcolor': levelColor?.value,
      'usermail': userMail?.value,
      'country': country?.value.toJson(),
      'province': province?.value.toJson(),
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
              'media_bigURL': avatar!.mediaURL.bigURL.value,
              'media_normalURL': avatar!.mediaURL.normalURL.value,
              'media_minURL': avatar!.mediaURL.minURL.value,
            }
          : null,
      'banner': banner != null
          ? {
              'media_ID': banner!.mediaID,
              'media_bigURL': banner!.mediaURL.bigURL.value,
              'media_normalURL': banner!.mediaURL.normalURL.value,
              'media_minURL': banner!.mediaURL.minURL.value,
            }
          : null,
      'myfriends': myFriends?.map((friend) => friend.toJson()).toList(),
      'chatlist': chatlist?.map((chat) => chat.toJson()).toList(),
      'myGroups': myGroups?.map((myGroups) => myGroups.toJson()).toList(),
      'lastlogin': lastlogin?.value,
      'lastloginv2': lastloginv2?.value,
      'widgetposts': widgetPosts?.map((posts) => posts.toJson()).toList(),
      'widgetstoriescard':
          widgetStoriescard?.map((stories) => stories.toJson()).toList(),
      'ismyFriend': ismyFriend?.value
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
        foregroundImage:
            CachedNetworkImageProvider(avatar!.mediaURL.minURL.value),
      ),
      title: CustomText.costum1(displayName!.value, weight: FontWeight.bold),
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
