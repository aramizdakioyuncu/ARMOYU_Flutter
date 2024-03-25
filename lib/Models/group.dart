import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';

class Group {
  int? groupID;
  String? groupName;
  String? groupshortName;

  Media? groupLogo;
  Media? groupBanner;
  String? groupType;
  String? groupURL;
  List<User>? groupUsers;

  Group({
    this.groupID,
    this.groupName,
    this.groupshortName,
    this.groupLogo,
    this.groupBanner,
    this.groupType,
    this.groupURL,
    this.groupUsers,
  });
}
