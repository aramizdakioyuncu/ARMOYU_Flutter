import 'package:ARMOYU/Models/user.dart';

class Like {
  final int likeID;
  final User user;
  final String date;

  Like({
    required this.likeID,
    required this.user,
    required this.date,
  });
}
