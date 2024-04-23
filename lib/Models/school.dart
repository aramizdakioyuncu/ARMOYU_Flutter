import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';

class School {
  int? schoolID;
  String? schoolName;
  String? schoolshortName;

  Media? schoolLogo;
  Media? schoolBanner;
  String? schoolURL;
  List<User>? schoolUsers;

  School({
    this.schoolID,
    this.schoolName,
    this.schoolshortName,
    this.schoolLogo,
    this.schoolBanner,
    this.schoolURL,
    this.schoolUsers,
  });
}
