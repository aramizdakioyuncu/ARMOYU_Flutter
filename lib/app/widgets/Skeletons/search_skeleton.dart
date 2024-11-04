import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonSearch extends StatefulWidget {
  const SkeletonSearch({super.key});

  @override
  State<SkeletonSearch> createState() => _SkeletonSearch();
}

class _SkeletonSearch extends State<SkeletonSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              child: Shimmer.fromColors(
                baseColor: Get.theme.disabledColor,
                highlightColor: Get.theme.highlightColor,
                child: const SizedBox(
                  width: 40,
                  height: 400,
                ),
              ),
              //  SkeletonAvatar(
              //     style: SkeletonAvatarStyle(
              //       shape: BoxShape.circle,
              //       width: 40,
              //       height: 40,
              //     ),
              //   ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Get.theme.disabledColor,
                  highlightColor: Get.theme.highlightColor,
                  child: const SizedBox(width: 100),
                ),
                // SkeletonLine(
                //   style: SkeletonLineStyle(width: 100),
                // ),

                // CustomDedectabletext().Costum1(text, 1, 15)
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Sağa yaslamak için
            children: [
              Shimmer.fromColors(
                baseColor: Get.theme.disabledColor,
                highlightColor: Get.theme.highlightColor,
                child: const SizedBox(width: 20),
              ),
              // SkeletonLine(
              //   style: SkeletonLineStyle(width: 20),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
