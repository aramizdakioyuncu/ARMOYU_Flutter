// ignore_for_file: use_key_in_widget_constructors, camel_case_types, must_be_immutable, prefer_const_constructors

import 'dart:developer';

import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Services/User.dart';

class Widget_PostComments extends StatefulWidget {
  final int userID;
  final String profileImageUrl;
  final String username;
  final String displayname;
  final int postID;
  final String comment;
  final int commentID;
  int islike;
  int commentslikecount;

  Widget_PostComments({
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
  State<Widget_PostComments> createState() => _Widget_PostComments();
}

class _Widget_PostComments extends State<Widget_PostComments> {
  Icon favoritestatus = Icon(Icons.favorite_outline);
  Color favoritelikestatus = Colors.grey;
  bool isvisiblecomment = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.islike == 1) {
      favoritestatus = Icon(Icons.favorite);
      favoritelikestatus = Colors.red;
    } else {
      favoritestatus = Icon(Icons.favorite_outline);
      favoritelikestatus = Colors.grey;
    }

    return Visibility(
      visible: isvisiblecomment,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(3),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userID: widget.userID, appbar: true),
                  ),
                );
              },
              child: CircleAvatar(
                foregroundImage:
                    CachedNetworkImageProvider(widget.profileImageUrl),
                radius: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Sola hizala
              children: [
                Text(widget.displayname),
                Text(widget.comment),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              int currentstatus = widget.islike;
              setState(() {
                if (currentstatus == 1) {
                  widget.islike = 0;
                  widget.commentslikecount--;
                } else {
                  widget.islike = 1;
                  widget.commentslikecount++;
                }
              });
              FunctionsPosts funct = FunctionsPosts();
              Map<String, dynamic> response =
                  await funct.commentlikeordislike(widget.commentID);
              if (response["durum"] == 0) {
                log(response["aciklama"]);
                return;
              }
              if (response['aciklama'] == "Paylaşımı beğendin.") {
                if (mounted) {
                  setState(() {
                    if (currentstatus == 1) {
                      widget.islike = 1;
                    }
                  });
                }
              } else {
                if (mounted) {
                  setState(() {
                    if (currentstatus == 0) {
                      widget.islike = 0;
                    }
                  });
                }
              }
            },
            icon: favoritestatus,
            color: favoritelikestatus,
          ),
          Text(widget.commentslikecount.toString()),
          Visibility(
            visible: User.ID != widget.userID,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ),
          Visibility(
            visible: User.ID == widget.userID,
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
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
