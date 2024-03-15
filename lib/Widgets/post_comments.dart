// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WidgetPostComments extends StatefulWidget {
  final int userID;
  final String profileImageUrl;
  final String username;
  final String displayname;
  final int postID;
  final String comment;
  final int commentID;
  int islike;
  int commentslikecount;

  WidgetPostComments({
    super.key,
    required this.userID,
    required this.profileImageUrl,
    required this.username,
    required this.displayname,
    required this.postID,
    required this.comment,
    required this.commentID,
    required this.islike,
    required this.commentslikecount,
  });

  @override
  State<WidgetPostComments> createState() => _WidgetPostComments();
}

class _WidgetPostComments extends State<WidgetPostComments> {
  Icon favoritestatus = const Icon(
    Icons.favorite_outline,
    size: 11,
  );
  Color favoritelikestatus = Colors.grey;
  bool isvisiblecomment = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.islike == 1) {
      favoritestatus = const Icon(Icons.favorite);
      favoritelikestatus = Colors.red;
    } else {
      favoritestatus = const Icon(Icons.favorite_outline);
      favoritelikestatus = Colors.grey;
    }

    return Visibility(
      visible: isvisiblecomment,
      child: ListTile(
        minLeadingWidth: 1.0,
        minVerticalPadding: 5.0,
        contentPadding: const EdgeInsets.all(0),
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  appbar: true,
                  userID: widget.userID,
                ),
              ),
            );
          },
          child: CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(widget.profileImageUrl),
            radius: 20,
          ),
        ),
        title: Text(widget.displayname),
        subtitle: Text(widget.comment),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                int currentstatus = widget.islike;
                setState(
                  () {
                    if (currentstatus == 1) {
                      widget.islike = 0;
                      widget.commentslikecount--;
                    } else {
                      widget.islike = 1;
                      widget.commentslikecount++;
                    }
                  },
                );
                FunctionsPosts funct = FunctionsPosts();
                Map<String, dynamic> response =
                    await funct.commentlikeordislike(widget.commentID);
                if (response["durum"] == 0) {
                  log(response["aciklama"]);
                  return;
                }
                if (response['aciklama'] == "Paylaşımı beğendin.") {
                  if (mounted) {
                    setState(
                      () {
                        if (currentstatus == 1) {
                          widget.islike = 1;
                        }
                      },
                    );
                  }
                } else {
                  if (mounted) {
                    setState(
                      () {
                        if (currentstatus == 0) {
                          widget.islike = 0;
                        }
                      },
                    );
                  }
                }
              },
              icon: favoritestatus,
              color: favoritelikestatus,
            ),
            Visibility(
              visible: ARMOYU.Appuser.userID == widget.userID,
              child: IconButton(
                onPressed: () async {
                  FunctionsPosts funct = FunctionsPosts();
                  Map<String, dynamic> response =
                      await funct.removecomment(widget.commentID);
                  if (response["durum"] == 0) {
                    log(response["aciklama"]);
                    return;
                  }
                  setState(() {
                    isvisiblecomment = false;
                  });
                },
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
