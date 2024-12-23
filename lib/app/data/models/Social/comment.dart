import 'dart:developer';
import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/post_comments/post_comments_controller.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  Future<void> likefunction(
    Function setstatefunction,
  ) async {
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

  Future<void> dislikefunction(
    Function setstatefunction,
  ) async {
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

  Future<bool> postLike(
    bool isLiked,
    setstatefunction,
  ) async {
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

  Widget commentlist(
    BuildContext context,
    Function setstatefunction,
  ) {
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
                  isLiked,
                  setstatefunction,
                ),
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

  Widget postCommentsWidget(BuildContext context,
      {required Function deleteFunction}) {
    final controller = Get.put(PostCommentsController(comment: this),
        tag: commentID.toString());

    final findCurrentAccountController = Get.find<AccountUserController>();

    return Obx(
      () => ListTile(
        minLeadingWidth: 1.0,
        minVerticalPadding: 5.0,
        contentPadding: const EdgeInsets.all(0),
        leading: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  PageFunctions functions = PageFunctions();
                  functions.pushProfilePage(
                    context,
                    User(userID: controller.xcomment!.value!.user.userID),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                    controller
                        .xcomment!.value!.user.avatar!.mediaURL.minURL.value,
                  ),
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
        title: Text(controller.xcomment!.value!.user.displayName!.value),
        subtitle: Text(controller.xcomment!.value!.content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await controller.likeunlikefunction();
              },
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    controller.favoritestatus,
                    const SizedBox(height: 3),
                    CustomText.costum1(
                      controller.xcomment!.value!.likeCount.toString(),
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: findCurrentAccountController
                        .currentUserAccounts.value.user.value.userID ==
                    controller.xcomment!.value!.user.userID,
                child: IconButton(
                  onPressed: () async => ARMOYUWidget.showConfirmationDialog(
                    context,
                    accept: () {
                      controller.removeComment(deleteFunction);
                    },
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
