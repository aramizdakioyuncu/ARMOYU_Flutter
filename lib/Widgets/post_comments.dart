import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Models/Social/comment.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WidgetPostComments extends StatefulWidget {
  final Comment comment;

  const WidgetPostComments({
    super.key,
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

  void setstatefunction() {
    if (mounted) {
      setState(() {});
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        appbar: true,
                        userID: widget.comment.user.userID,
                        scrollController: ScrollController(),
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundImage: CachedNetworkImageProvider(
                      widget.comment.user.avatar!.mediaURL.minURL),
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
        title: Text(widget.comment.user.displayName!),
        subtitle: Text(widget.comment.content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                bool currentstatus = widget.comment.didIlike;
                if (currentstatus) {
                  widget.comment.didIlike = false;
                  widget.comment.likeCount--;
                } else {
                  widget.comment.didIlike = true;
                  widget.comment.likeCount++;
                }
                setstatefunction();
                FunctionsPosts funct = FunctionsPosts();
                Map<String, dynamic> response;
                if (!widget.comment.didIlike) {
                  response =
                      await funct.commentdislike(widget.comment.commentID);
                } else {
                  response = await funct.commentlike(widget.comment.commentID);
                }
                if (response["durum"] == 0) {
                  log(response["aciklama"]);
                  if (currentstatus) {
                    widget.comment.likeCount--;
                  } else {
                    widget.comment.likeCount++;
                  }
                  widget.comment.didIlike = !widget.comment.didIlike;
                  setstatefunction();
                  return;
                }
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
              visible: ARMOYU.appUser.userID == widget.comment.user.userID,
              child: IconButton(
                onPressed: () async {
                  FunctionsPosts funct = FunctionsPosts();
                  Map<String, dynamic> response =
                      await funct.removecomment(widget.comment.commentID);
                  if (response["durum"] == 0) {
                    log(response["aciklama"]);
                    return;
                  }
                  setState(() {
                    isvisiblecomment = false;
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
