import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonComments extends StatefulWidget {
  const SkeletonComments({super.key});
  @override
  State<SkeletonComments> createState() => _SkeletonComments();
}

class _SkeletonComments extends State<SkeletonComments> {
  Icon favoritestatus = const Icon(Icons.favorite_outline);
  Color favoritelikestatus = Colors.grey;
  bool isvisiblecomment = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    favoritestatus = const Icon(Icons.favorite);
    favoritelikestatus = Colors.black;

    return Visibility(
      visible: isvisiblecomment,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: GestureDetector(
              onTap: () {},
              child: const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
              )),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Sola hizala
              children: [
                SkeletonLine(style: SkeletonLineStyle(width: 80)),
                SizedBox(height: 10),
                SkeletonLine(style: SkeletonLineStyle(width: 250)),
              ],
            ),
          ),
          const SkeletonItem(child: Icon(Icons.favorite)),
        ],
      ),
    );
  }
}
