import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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
        color: Get.theme.scaffoldBackgroundColor,
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
                  child: Shimmer.fromColors(
                    baseColor: Get.theme.disabledColor,
                    highlightColor: Get.theme.highlightColor,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  ),
                  // const SkeletonAvatar(
                  //   style: SkeletonAvatarStyle(
                  //     shape: BoxShape.circle,
                  //     width: 40,
                  //     height: 40,
                  //   ),
                  // ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Get.theme.disabledColor,
                        highlightColor: Get.theme.highlightColor,
                        child: const SizedBox(
                          width: 100,
                        ),
                      ),

                      // SkeletonLine(
                      //   style: SkeletonLineStyle(width: 100),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Shimmer.fromColors(
                          baseColor: Get.theme.disabledColor,
                          highlightColor: Get.theme.highlightColor,
                          child: const SizedBox(width: 20),
                        ),
                        //  SkeletonLine(
                        //   style: SkeletonLineStyle(width: 20),
                        // ),
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
            child: Shimmer.fromColors(
              baseColor: Get.theme.disabledColor,
              highlightColor: Get.theme.highlightColor,
              child: const SizedBox(
                // width: 600,
                height: 140,
              ),
            ),
            //  SkeletonParagraph(
            //   style: const SkeletonParagraphStyle(lines: 2),
            // ),
          ), // Tıklanabilir metin için yeni fonksiyon
          const SizedBox(height: 5),
          Center(
            child: Shimmer.fromColors(
              baseColor: Get.theme.disabledColor,
              highlightColor: Get.theme.highlightColor,
              child: SizedBox(
                width: ARMOYU.screenWidth / 1,
                height: 400,
              ),
            ),

            // SkeletonAvatar(
            //   style: SkeletonAvatarStyle(
            //     width: ARMOYU.screenWidth / 1,
            //     height: 400,
            //   ),
            // ),
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
