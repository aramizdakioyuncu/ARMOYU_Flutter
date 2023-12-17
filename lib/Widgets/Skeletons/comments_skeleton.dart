// ignore_for_file: use_key_in_widget_constructors, camel_case_types, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonComments extends StatefulWidget {
  // SkeletonComments({

  // });

  @override
  State<SkeletonComments> createState() => _SkeletonComments();
}

class _SkeletonComments extends State<SkeletonComments> {
  Icon favoritestatus = Icon(Icons.favorite_outline);
  Color favoritelikestatus = Colors.grey;
  bool isvisiblecomment = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    favoritestatus = Icon(Icons.favorite);
    favoritelikestatus = Colors.black;

    return Visibility(
      visible: isvisiblecomment,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(3),
            child: GestureDetector(
              onTap: () {},
              child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
              )),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Sola hizala
              children: const [
                SkeletonLine(style: SkeletonLineStyle(width: 80)),
                SizedBox(height: 10),
                SkeletonLine(style: SkeletonLineStyle(width: 250)),
              ],
            ),
          ),
          SkeletonItem(child: Icon(Icons.favorite)),
        ],
      ),
    );
  }
}
