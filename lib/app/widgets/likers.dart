// ignore_for_file: must_be_immutable

import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LikersListWidget extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final User user;
  final String date;
  int islike;

  LikersListWidget({
    super.key,
    required this.currentUserAccounts,
    required this.user,
    required this.date,
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
          PageFunctions functions = PageFunctions(
            currentUser: widget.currentUserAccounts.user.value,
          );
          functions.pushProfilePage(
            context,
            User(
              userID: widget.user.userID,
            ),
            ScrollController(),
          );
        },
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundImage: CachedNetworkImageProvider(
            widget.user.avatar!.mediaURL.minURL.value,
          ),
          radius: 20,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.user.displayName!.value),
          Text(
            widget.date,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
