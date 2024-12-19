import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LikersListWidget extends StatelessWidget {
  final User user;
  final String date;
  int islike;

  LikersListWidget({
    super.key,
    required this.user,
    required this.date,
    required this.islike,
  });

  Icon favoritestatus = const Icon(Icons.favorite_outline);
  Color favoritelikestatus = Colors.grey;

  @override
  Widget build(BuildContext context) {
    if (islike == 1) {
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
          PageFunctions functions = PageFunctions();
          functions.pushProfilePage(
            context,
            User(userID: user.userID),
          );
        },
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundImage: CachedNetworkImageProvider(
            user.avatar!.mediaURL.minURL.value,
          ),
          radius: 20,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.displayName!.value),
          Text(
            date,
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
