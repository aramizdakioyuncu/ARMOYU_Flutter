// ignore_for_file: must_be_immutable

import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    super.key,
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
  Icon favoritestatus = const Icon(Icons.favorite_outline);
  Color favoritelikestatus = Colors.grey;

  @override
  Widget build(BuildContext context) {
    if (widget.islike == 1) {
      favoritestatus = const Icon(Icons.favorite);
      favoritelikestatus = Colors.red;
    } else {
      favoritestatus = const Icon(Icons.favorite_outline);
      favoritelikestatus = Colors.grey;
    }

    return ListTile(
      minLeadingWidth: 1.0,
      minVerticalPadding: 5.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      leading: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                appbar: false,
                currentUser: User(
                  userID: widget.userID,
                ),
                scrollController: ScrollController(),
              ),
            ),
          );
        },
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundImage: CachedNetworkImageProvider(widget.profileImageUrl),
          radius: 20,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.displayname),
          Text(widget.comment,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
