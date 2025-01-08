import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:armoyu_widgets/data/models/Social/comment.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCommentsController extends GetxController {
  final Comment comment;
  PostCommentsController({required this.comment});

  Rxn<Comment>? xcomment;
  @override
  void onInit() {
    super.onInit();

    xcomment = Rxn<Comment>(comment);

    if (xcomment!.value!.didIlike == true) {
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

  Future<void> removeComment(Function deleteFunction) async {
    PostRemoveCommentResponse response = await API.service.postsServices
        .removecomment(commentID: xcomment!.value!.commentID);
    ARMOYUWidget.toastNotification(response.result.description.toString());

    if (!response.result.status) {
      return;
    }

    deleteFunction();
  }

  Future<void> likeunlikefunction() async {
    bool currentstatus = xcomment!.value!.didIlike;
    if (currentstatus) {
      xcomment!.value!.didIlike = false;
      xcomment!.value!.likeCount--;
    } else {
      xcomment!.value!.didIlike = true;
      xcomment!.value!.likeCount++;
    }

    if (!xcomment!.value!.didIlike) {
      PostCommentUnLikeResponse response = await API.service.postsServices
          .commentunlike(commentID: xcomment!.value!.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          xcomment!.value!.likeCount--;
        } else {
          xcomment!.value!.likeCount++;
        }
        xcomment!.value!.didIlike = !xcomment!.value!.didIlike;
        return;
      }
    } else {
      PostCommentLikeResponse response = await API.service.postsServices
          .commentlike(commentID: xcomment!.value!.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          xcomment!.value!.likeCount--;
        } else {
          xcomment!.value!.likeCount++;
        }
        xcomment!.value!.didIlike = !xcomment!.value!.didIlike;
        return;
      }
    }
  }
}
