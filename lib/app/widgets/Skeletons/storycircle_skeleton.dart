import 'package:armoyu_widgets/data/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonStorycircle extends StatefulWidget {
  final User? currentUser;
  final int count;

  const SkeletonStorycircle({
    super.key,
    required this.currentUser,
    required this.count,
  });

  @override
  State<SkeletonStorycircle> createState() => _SkeletonStorycircleState();
}

class _SkeletonStorycircleState extends State<SkeletonStorycircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.count,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: index == 0
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.transparent,
                              width: 3.0, // Kenarlık kalınlığı
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: CachedNetworkImageProvider(
                                widget
                                    .currentUser!.avatar!.mediaURL.minURL.value,
                              ),
                            ),
                          )
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: index % 3 == 1 || index == 0
                                  ? Colors.transparent
                                  : Colors.green, // Kenarlık rengi
                              width: 3.0, // Kenarlık kalınlığı
                            ),
                          ),
                    child: index == 0
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(100, 100))),
                              child: const Icon(
                                Icons.add,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : Shimmer.fromColors(
                            baseColor: Get.theme.disabledColor,
                            highlightColor: Get.theme.highlightColor,
                            child: const SizedBox(
                              width: 40,
                              height: 40,
                            ),
                          ),
                    // const SkeletonAvatar(
                    //     style: SkeletonAvatarStyle(
                    //       shape: BoxShape.circle,
                    //       width: 40,
                    //       height: 40,
                    //     ),
                    //   ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
