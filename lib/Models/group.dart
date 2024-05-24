import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';

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
}

class GroupSocial {
  String? discord;
  String? web;

  GroupSocial({
    required this.discord,
    required this.web,
  });
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
}
