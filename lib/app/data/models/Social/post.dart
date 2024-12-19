import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

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
  List<Comment>? firstthreecomment;
  List<Comment>? comments;
  List<Like>? firstthreelike;
  List<Like>? likers;

  String? location;

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
    required this.firstthreecomment,
    this.comments,
    required this.firstthreelike,
    this.likers,
    required this.location,
  });

  // Post nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'postID': postID,
      'content': content,
      'postDate': postDate,
      'sharedDevice': sharedDevice,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLikeme': isLikeme,
      'iscommentMe': iscommentMe,
      'owner': owner.toJson(),
      'media': media.map((m) => m.toJson()).toList(),
      'firstthreecomment': firstthreecomment?.map((c) => c.toJson()).toList(),
      'comments': comments?.map((c) => c.toJson()).toList(),
      'firstthreelike': firstthreelike?.map((l) => l.toJson()).toList(),
      'likers': likers?.map((l) => l.toJson()).toList(),
      'location': location,
    };
  }

  // JSON'dan Post nesnesine dönüşüm
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postID: json['postID'],
      content: json['content'],
      postDate: json['postDate'],
      sharedDevice: json['sharedDevice'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      isLikeme: json['isLikeme'],
      iscommentMe: json['iscommentMe'],
      owner: User.fromJson(json['owner']),
      media: (json['media'] as List).map((m) => Media.fromJson(m)).toList(),
      firstthreecomment: json['firstthreecomment'] != null
          ? (json['firstthreecomment'] as List)
              .map((c) => Comment.fromJson(c))
              .toList()
              .obs
          : null,
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((c) => Comment.fromJson(c))
              .toList()
              .obs
          : null,
      firstthreelike: json['firstthreelike'] != null
          ? (json['firstthreelike'] as List)
              .map((l) => Like.fromJson(l))
              .toList()
              .obs
          : null,
      likers: json['likers'] != null
          ? (json['likers'] as List).map((l) => Like.fromJson(l)).toList().obs
          : null,
      location: json['location'],
    );
  }
}
