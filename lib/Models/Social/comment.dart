import 'package:ARMOYU/Models/user.dart';

class Comment {
  final int commentID;
  final int postID;
  final User user;
  String content;
  int likeCount;
  bool didIlike;

  Comment({
    required this.commentID,
    required this.postID,
    required this.user,
    required this.content,
    required this.likeCount,
    required this.didIlike,
  });
}
