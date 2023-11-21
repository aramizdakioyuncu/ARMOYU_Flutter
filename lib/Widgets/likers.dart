// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Functions/posts.dart';

class LikersListWidget extends StatefulWidget {
  final int userID;
  final String profileImageUrl;
  final String username;
  final String displayname;
  final int postID;
  final String comment;
  final int commentID;
  int islike;

  LikersListWidget({
    required this.userID,
    required this.profileImageUrl,
    required this.username,
    required this.displayname,
    required this.postID,
    required this.comment,
    required this.commentID,
    required this.islike,
  });

  @override
  State<LikersListWidget> createState() => _TwitterPostWidgetStat3e();
}

class _TwitterPostWidgetStat3e extends State<LikersListWidget> {
  Icon favoritestatus = Icon(Icons.favorite_outline);
  Color favoritelikestatus = Colors.grey;

  @override
  Widget build(BuildContext context) {
    if (widget.islike == 1) {
      favoritestatus = Icon(Icons.favorite);
      favoritelikestatus = Colors.red;
    } else {
      favoritestatus = Icon(Icons.favorite_outline);
      favoritelikestatus = Colors.grey;
    }

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(3),
          child: CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(widget.profileImageUrl),
            radius: 20,
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
            FunctionsPosts funct = FunctionsPosts();
            Map<String, dynamic> response =
                await funct.commentlikeordislike(widget.commentID);
            if (response["durum"] == 0) {
              print(response["aciklama"]);
              return;
            }
            if (response['aciklama'] == "Paylaşımı beğendin.") {
              setState(() {
                widget.islike = 1;
              });
            } else {
              setState(() {
                widget.islike = 0;
              });
            }
          },
          icon: favoritestatus,
          color: favoritelikestatus,
        ),
      ],
    );
  }
}
