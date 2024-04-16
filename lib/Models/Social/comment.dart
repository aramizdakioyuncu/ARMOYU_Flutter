import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  Widget commentlist(BuildContext context, Function setstatefunction) {
    return Container(
      color: ARMOYU.backgroundcolor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    appbar: false,
                    scrollController: ScrollController(),
                    username: user.userName,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundImage:
                  CachedNetworkImageProvider(user.avatar!.mediaURL.minURL),
              radius: 10,
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: CustomText.usercomments(context, text: content, user: user),
          ),
          GestureDetector(
            onTap: () async {
              bool currentstatus = didIlike;
              if (currentstatus) {
                didIlike = false;
                likeCount--;
              } else {
                didIlike = true;
                likeCount++;
              }
              setstatefunction();
              FunctionsPosts funct = FunctionsPosts();
              Map<String, dynamic> response;
              if (!didIlike) {
                response = await funct.commentdislike(commentID);
              } else {
                response = await funct.commentlike(commentID);
              }
              if (response["durum"] == 0) {
                log(response["aciklama"]);
                if (currentstatus) {
                  likeCount--;
                } else {
                  likeCount++;
                }
                didIlike = !didIlike;
                setstatefunction();
                return;
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: didIlike
                  ? Row(
                      children: [
                        SizedBox(
                          width: 35,
                          child: CustomText.costum1(
                            likeCount.toString(),
                            align: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.favorite, size: 15, color: Colors.red),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: 35,
                          child: CustomText.costum1(
                            likeCount.toString(),
                            align: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.favorite_outline_rounded, size: 15),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
