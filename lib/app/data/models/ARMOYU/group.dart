import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class Group {
  int? groupID;
  String? groupName;
  String? groupshortName;
  String? description;

  Media? groupLogo;
  Media? groupBanner;
  String? groupType;
  String? groupURL;
  List<User>? groupUsers;
  int? groupUsersCount;
  bool? joinStatus;

  GroupSocial? groupSocial;
  GroupRoles? myRole;

  Group({
    this.groupID,
    this.groupName,
    this.groupshortName,
    this.description,
    this.groupLogo,
    this.groupBanner,
    this.groupType,
    this.groupURL,
    this.groupUsers,
    this.groupUsersCount,
    this.joinStatus,
    this.groupSocial,
    this.myRole,
  });

  // Group nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'groupName': groupName,
      'groupshortName': groupshortName,
      'description': description,
      'groupLogo': groupLogo?.toJson(),
      'groupBanner': groupBanner?.toJson(),
      'groupType': groupType,
      'groupURL': groupURL,
      'groupUsers': groupUsers?.map((user) => user.toJson()).toList(),
      'groupUsersCount': groupUsersCount,
      'joinStatus': joinStatus,
      'groupSocial': groupSocial?.toJson(),
      'myRole': myRole?.toJson(),
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupID: json['groupID'],
      groupName: json['groupName'],
      groupshortName: json['groupshortName'],
      description: json['description'],
      groupLogo:
          json['groupLogo'] != null ? Media.fromJson(json['groupLogo']) : null,
      groupBanner: json['groupBanner'] != null
          ? Media.fromJson(json['groupBanner'])
          : null,
      groupType: json['groupType'],
      groupURL: json['groupURL'],
      groupUsers: json['groupUsers'] != null
          ? (json['groupUsers'] as List<dynamic>)
              .map((user) => User.fromJson(user))
              .toList()
          : null,
      groupUsersCount: json['groupUsersCount'],
      joinStatus: json['joinStatus'],
      groupSocial: json['groupSocial'] != null
          ? GroupSocial.fromJson(json['groupSocial'])
          : null,
      myRole:
          json['myRole'] != null ? GroupRoles.fromJson(json['myRole']) : null,
    );
  }
}

class GroupSocial {
  String? discord;
  String? web;

  GroupSocial({
    required this.discord,
    required this.web,
  });

  // GroupSocial nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'discord': discord,
      'web': web,
    };
  }

  // JSON'dan GroupSocial nesnesine dönüşüm
  factory GroupSocial.fromJson(Map<String, dynamic> json) {
    return GroupSocial(
      discord: json['discord'],
      web: json['web'],
    );
  }
}

class GroupRoles {
  bool owner;
  bool userInvite;
  bool userKick;
  bool userRole;
  bool groupSettings;
  bool groupFiles;
  bool groupEvents;
  bool groupRole;
  bool groupSurvey;

  GroupRoles({
    required this.owner,
    required this.userInvite,
    required this.userKick,
    required this.userRole,
    required this.groupSettings,
    required this.groupFiles,
    required this.groupEvents,
    required this.groupRole,
    required this.groupSurvey,
  });

  // GroupRoles nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'userInvite': userInvite,
      'userKick': userKick,
      'userRole': userRole,
      'groupSettings': groupSettings,
      'groupFiles': groupFiles,
      'groupEvents': groupEvents,
      'groupRole': groupRole,
      'groupSurvey': groupSurvey,
    };
  }

  // JSON'dan GroupRoles nesnesine dönüşüm
  factory GroupRoles.fromJson(Map<String, dynamic> json) {
    return GroupRoles(
      owner: json['owner'],
      userInvite: json['userInvite'],
      userKick: json['userKick'],
      userRole: json['userRole'],
      groupSettings: json['groupSettings'],
      groupFiles: json['groupFiles'],
      groupEvents: json['groupEvents'],
      groupRole: json['groupRole'],
      groupSurvey: json['groupSurvey'],
    );
  }
}
