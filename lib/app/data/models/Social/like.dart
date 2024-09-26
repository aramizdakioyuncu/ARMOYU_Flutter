import 'package:ARMOYU/app/data/models/user.dart';

class Like {
  final int likeID;
  final User user;
  final String date;

  Like({
    required this.likeID,
    required this.user,
    required this.date,
  });
  // Like nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'likeID': likeID,
      'user': user.toJson(),
      'date': date,
    };
  }

  // JSON'dan Comment nesnesine dönüşüm
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      likeID: json['likeID'],
      user: User.fromJson(json['user']),
      date: json['date'],
    );
  }
}
