// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonSearch extends StatefulWidget {
  // SkeletonSearch({

  // });

  @override
  State<SkeletonSearch> createState() => _SkeletonSearch();
}

class _SkeletonSearch extends State<SkeletonSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 10 birimlik boşluk ekledik
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => ProfilePage(userID: userID, appbar: true),
              // ));
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors
                  .transparent, // Set a background color for the avatar if needed
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  shape: BoxShape.circle,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(width: 100),
                ),

                // CustomDedectabletext().Costum1(text, 1, 15)
              ],
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Sağa yaslamak için
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(width: 20),
              )
            ],
          ),
        ],
      ),
    );
  }
}
