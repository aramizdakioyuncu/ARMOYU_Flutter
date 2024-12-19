import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCommentsController extends GetxController {
  final Comment comment;
  PostCommentsController({required this.comment});

  @override
  void onInit() {
    super.onInit();

    if (comment.didIlike == true) {
      favoritestatus = const Icon(
        Icons.favorite_rounded,
        color: Colors.red,
        size: 20,
      );
    } else {
      favoritestatus = const Icon(
        Icons.favorite_outline_rounded,
        color: Colors.grey,
        size: 20,
      );
    }
  }

  Icon favoritestatus =
      const Icon(Icons.favorite_outline_rounded, color: Colors.grey, size: 20);
  bool isvisiblecomment = true;

  Future<void> removeComment() async {
    isvisiblecomment = false;

    PostRemoveCommentResponse response = await API.service.postsServices
        .removecomment(commentID: comment.commentID);
    ARMOYUWidget.toastNotification(response.result.description.toString());

    if (!response.result.status) {
      isvisiblecomment = true;
      return;
    }
  }

  Future<void> likeunlikefunction() async {
    bool currentstatus = comment.didIlike;
    if (currentstatus) {
      comment.didIlike = false;
      comment.likeCount--;
    } else {
      comment.didIlike = true;
      comment.likeCount++;
    }

    if (!comment.didIlike) {
      PostCommentUnLikeResponse response = await API.service.postsServices
          .commentunlike(commentID: comment.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          comment.likeCount--;
        } else {
          comment.likeCount++;
        }
        comment.didIlike = !comment.didIlike;
        return;
      }
    } else {
      PostCommentLikeResponse response = await API.service.postsServices
          .commentlike(commentID: comment.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          comment.likeCount--;
        } else {
          comment.likeCount++;
        }
        comment.didIlike = !comment.didIlike;
        return;
      }
    }
  }
}
