import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WidgetPostComments extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final Comment comment;

  const WidgetPostComments({
    super.key,
    required this.currentUserAccounts,
    required this.comment,
  });

  @override
  State<WidgetPostComments> createState() => _WidgetPostComments();
}

class _WidgetPostComments extends State<WidgetPostComments> {
  Icon favoritestatus =
      const Icon(Icons.favorite_outline_rounded, color: Colors.grey, size: 20);
  bool isvisiblecomment = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> removeComment() async {
    isvisiblecomment = false;

    PostRemoveCommentResponse response = await API.service.postsServices
        .removecomment(commentID: widget.comment.commentID);
    ARMOYUWidget.toastNotification(response.result.description.toString());

    if (!response.result.status) {
      isvisiblecomment = true;
      return;
    }
  }

  Future<void> likeunlikefunction() async {
    bool currentstatus = widget.comment.didIlike;
    if (currentstatus) {
      widget.comment.didIlike = false;
      widget.comment.likeCount--;
    } else {
      widget.comment.didIlike = true;
      widget.comment.likeCount++;
    }

    if (!widget.comment.didIlike) {
      PostCommentUnLikeResponse response = await API.service.postsServices
          .commentunlike(commentID: widget.comment.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          widget.comment.likeCount--;
        } else {
          widget.comment.likeCount++;
        }
        widget.comment.didIlike = !widget.comment.didIlike;
        return;
      }
    } else {
      PostCommentLikeResponse response = await API.service.postsServices
          .commentlike(commentID: widget.comment.commentID);

      if (!response.result.status) {
        log(response.result.description);
        if (currentstatus) {
          widget.comment.likeCount--;
        } else {
          widget.comment.likeCount++;
        }
        widget.comment.didIlike = !widget.comment.didIlike;
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comment.didIlike == true) {
      favoritestatus =
          const Icon(Icons.favorite_rounded, color: Colors.red, size: 20);
    } else {
      favoritestatus = const Icon(Icons.favorite_outline_rounded,
          color: Colors.grey, size: 20);
    }

    return Visibility(
      visible: isvisiblecomment,
      child: ListTile(
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
                  PageFunctions functions = PageFunctions(
                    currentUser: widget.currentUserAccounts.user.value,
                  );
                  functions.pushProfilePage(
                    context,
                    User(
                      userID: widget.comment.user.userID,
                    ),
                    ScrollController(),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                    widget.comment.user.avatar!.mediaURL.minURL.value,
                  ),
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
        title: Text(widget.comment.user.displayName!.value),
        subtitle: Text(widget.comment.content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await likeunlikefunction();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  favoritestatus,
                  const SizedBox(height: 3),
                  CustomText.costum1(widget.comment.likeCount.toString(),
                      weight: FontWeight.bold),
                ],
              ),
            ),
            Visibility(
              visible: widget.currentUserAccounts.user.value.userID ==
                  widget.comment.user.userID,
              child: IconButton(
                onPressed: () async => ARMOYUWidget.showConfirmationDialog(
                  context,
                  accept: removeComment,
                ),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
