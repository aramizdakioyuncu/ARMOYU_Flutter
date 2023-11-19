// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sort_child_properties_last, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:ARMOYU/Core/screen.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonSocailPosts extends StatefulWidget {
  // TwitterPostWidget({});

  @override
  State<SkeletonSocailPosts> createState() => _SkeletonSocailPosts();
}

class _SkeletonSocailPosts extends State<SkeletonSocailPosts> {
  // TextEditingController controller_message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(width: 100),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: SkeletonLine(
                          style: SkeletonLineStyle(width: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.more_vert,
                      color: Colors.grey.shade800,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(lines: 2),
              )), // Tıklanabilir metin için yeni fonksiyon
          SizedBox(height: 5),
          Center(
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: Screen.screenWidth / 1,
                height: 400,
              ),
            ),
          ), // Medya içeriği için yeni fonksiyon
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.favorite_outline, color: Colors.grey.shade800),
                SizedBox(width: 5),
                Spacer(),
                Icon(Icons.comment_outlined, color: Colors.grey.shade800),
                Spacer(),
                Icon(Icons.cyclone_outlined,
                    color:
                        Colors.grey.shade800), // Retweet simgesi (yeşil renkte)
                Spacer(),
                Icon(Icons.share_outlined,
                    color: Colors.grey.shade800), // Paylaşım simgesi
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
