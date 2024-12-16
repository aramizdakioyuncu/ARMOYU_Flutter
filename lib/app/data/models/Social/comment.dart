import 'dart:developer';
import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class Comment {
  final int commentID;
  final int postID;
  final User user;
  final String date;
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
    required this.date,
  });

  // Comment nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'commentID': commentID,
      'postID': postID,
      'user': user.toJson(),
      'date': date,
      'content': content,
      'likeCount': likeCount,
      'didIlike': didIlike,
    };
  }

  // JSON'dan Comment nesnesine dönüşüm
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentID: json['commentID'],
      postID: json['postID'],
      user: User.fromJson(json['user']),
      date: json['date'],
      content: json['content'],
      likeCount: json['likeCount'],
      didIlike: json['didIlike'],
    );
  }

  bool likeunlikeProcces = false;
  final GlobalKey<LikeButtonState> _likeButtonKey =
      GlobalKey<LikeButtonState>();
  Future<void> likefunction(Function setstatefunction,
      {required User currentUser}) async {
    if (likeunlikeProcces) {
      return;
    }
    likeunlikeProcces = true;

    PostCommentLikeResponse response =
        await API.service.postsServices.commentlike(commentID: commentID);
    if (!response.result.status) {
      log(response.result.description);
      likeunlikeProcces = false;
      setstatefunction();
      return;
    }
    likeCount++;
    didIlike = true;
    likeunlikeProcces = false;
    setstatefunction();
  }

  Future<void> dislikefunction(Function setstatefunction,
      {required User currentUser}) async {
    if (likeunlikeProcces) {
      return;
    }
    likeunlikeProcces = true;

    PostCommentUnLikeResponse response =
        await API.service.postsServices.commentunlike(commentID: commentID);
    if (!response.result.status) {
      log(response.result.description);
      likeunlikeProcces = false;
      setstatefunction();

      return;
    }
    likeCount--;
    didIlike = false;
    likeunlikeProcces = false;
    setstatefunction();
  }

  Future<bool> postLike(bool isLiked, setstatefunction,
      {required User currentUser}) async {
    if (likeunlikeProcces) {
      return isLiked;
    }

    if (isLiked) {
      dislikefunction(setstatefunction, currentUser: currentUser);
    } else {
      likefunction(setstatefunction, currentUser: currentUser);
    }
    return !isLiked;
  }

  Widget commentlist(BuildContext context, Function setstatefunction,
      {required UserAccounts currentUserAccounts}) {
    return GestureDetector(
      onDoubleTap: () {
        _likeButtonKey.currentState?.onTap();
      },
      child: Container(
        color: Get.theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.usercomments(
                    context,
                    currentUserAccounts: currentUserAccounts,
                    text: content,
                    user: user,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: LikeButton(
                key: _likeButtonKey,
                isLiked: didIlike,
                likeCount: likeCount,
                onTap: (isLiked) async => await postLike(
                    isLiked, setstatefunction,
                    currentUser: currentUserAccounts.user.value),
                likeBuilder: (bool isLiked) {
                  return Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 15,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
