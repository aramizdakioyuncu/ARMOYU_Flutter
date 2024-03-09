import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonSocailPosts extends StatefulWidget {
  const SkeletonSocailPosts({super.key});

  @override
  State<SkeletonSocailPosts> createState() => _SkeletonSocailPosts();
}

class _SkeletonSocailPosts extends State<SkeletonSocailPosts> {
  // TextEditingController controller_message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: ARMOYU.bacgroundcolor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(width: 100),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SkeletonParagraph(
                style: const SkeletonParagraphStyle(lines: 2),
              )), // Tıklanabilir metin için yeni fonksiyon
          const SizedBox(height: 5),
          Center(
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: ARMOYU.screenWidth / 1,
                height: 400,
              ),
            ),
          ), // Medya içeriği için yeni fonksiyon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            child: Row(
              children: [
                const Spacer(),
                Icon(Icons.favorite_outline, color: Colors.grey.shade800),
                const SizedBox(width: 5),
                const Spacer(),
                Icon(Icons.comment_outlined, color: Colors.grey.shade800),
                const Spacer(),
                Icon(Icons.cyclone_outlined,
                    color:
                        Colors.grey.shade800), // Retweet simgesi (yeşil renkte)
                const Spacer(),
                Icon(Icons.share_outlined,
                    color: Colors.grey.shade800), // Paylaşım simgesi
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
