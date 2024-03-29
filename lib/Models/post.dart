import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';

class Post {
  int postID;
  String content;
  String postDate;
  String sharedDevice;
  int likesCount;
  int commentsCount;
  bool isLikeme;
  bool iscommentMe;
  User owner;
  List<Media> media;

  Post({
    required this.postID,
    required this.content,
    required this.postDate,
    required this.sharedDevice,
    required this.likesCount,
    required this.isLikeme,
    required this.commentsCount,
    required this.iscommentMe,
    required this.owner,
    required this.media,
  });
}
