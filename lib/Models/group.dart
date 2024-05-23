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
