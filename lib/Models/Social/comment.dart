import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:flutter/material.dart';
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
  bool likeunlikeProcces = false;
  final GlobalKey<LikeButtonState> _likeButtonKey =
      GlobalKey<LikeButtonState>();
  Future<void> likefunction(Function setstatefunction) async {
    if (likeunlikeProcces) {
      return;
    }
    likeunlikeProcces = true;
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response;
    response = await funct.commentlike(commentID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      likeunlikeProcces = false;
      setstatefunction();
      return;
    }
    likeCount++;
    didIlike = true;
    likeunlikeProcces = false;
    setstatefunction();
  }

  Future<void> dislikefunction(Function setstatefunction) async {
    if (likeunlikeProcces) {
      return;
    }
    likeunlikeProcces = true;

    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response;
    response = await funct.commentdislike(commentID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      likeunlikeProcces = false;
      setstatefunction();

      return;
    }
    likeCount--;
    didIlike = false;
    likeunlikeProcces = false;
    setstatefunction();
  }

  Future<bool> postLike(bool isLiked, setstatefunction) async {
    if (likeunlikeProcces) {
      return isLiked;
    }

    if (isLiked) {
      dislikefunction(setstatefunction);
    } else {
      likefunction(setstatefunction);
    }
    return !isLiked;
  }

  Widget commentlist(BuildContext context, Function setstatefunction) {
    return GestureDetector(
      onDoubleTap: () {
        _likeButtonKey.currentState?.onTap();
      },
      child: Container(
        color: ARMOYU.backgroundcolor,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.usercomments(
                    context,
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
                onTap: (isLiked) async =>
                    await postLike(isLiked, setstatefunction),
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
