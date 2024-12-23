import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/post_likers/post_likers_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class WidgetPostLikersView extends StatelessWidget {
  final User user;
  final String date;
  int islike;

  WidgetPostLikersView({
    super.key,
    required this.user,
    required this.date,
    required this.islike,
  });

  @override
  Widget build(BuildContext context) {
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

    Get.put(
      PostLikersController(date: date, islike: islike, user: user),
      tag: uniqueTag,
    );

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
              color: Get.theme.primaryColor.withOpacity(0.69),
            ),
          ),
        ],
      ),
    );
  }
}
