import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class School {
  int? schoolID;
  String? schoolName;
  String? schoolshortName;

  Media? schoolLogo;
  Media? schoolBanner;
  String? schoolURL;
  List<User>? schoolUsers;
  int? schoolUsersCount;

  School({
    this.schoolID,
    this.schoolName,
    this.schoolshortName,
    this.schoolLogo,
    this.schoolBanner,
    this.schoolURL,
    this.schoolUsers,
    this.schoolUsersCount,
  });

  // Convert School instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'schoolID': schoolID,
      'schoolName': schoolName,
      'schoolshortName': schoolshortName,
      'schoolLogo': schoolLogo?.toJson(),
      'schoolBanner': schoolBanner?.toJson(),
      'schoolURL': schoolURL,
      'schoolUsers': schoolUsers?.map((user) => user.toJson()).toList(),
      'schoolUsersCount': schoolUsersCount,
    };
  }

  // Convert JSON to School instance
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolID: json['schoolID'],
      schoolName: json['schoolName'],
      schoolshortName: json['schoolshortName'],
      schoolLogo: json['schoolLogo'] != null
          ? Media.fromJson(json['schoolLogo'])
          : null,
      schoolBanner: json['schoolBanner'] != null
          ? Media.fromJson(json['schoolBanner'])
          : null,
      schoolURL: json['schoolURL'],
      schoolUsers: (json['schoolUsers'] as List<dynamic>?)
          ?.map((user) => User.fromJson(user))
          .toList(),
      schoolUsersCount: json['schoolUsersCount'],
    );
  }
}
