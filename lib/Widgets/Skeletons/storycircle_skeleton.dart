// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ARMOYU/Services/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonStorycircle extends StatefulWidget {
  final int count;

  SkeletonStorycircle({
    required this.count,
  });

  @override
  State<SkeletonStorycircle> createState() => _SkeletonStorycircleState();
}

class _SkeletonStorycircleState extends State<SkeletonStorycircle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 80,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.count,
          physics: BouncingScrollPhysics(),
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
                          User.avatar,
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
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(100, 100))),
                        child: Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        shape: BoxShape.circle,
                        width: 40,
                        height: 40,
                      ),
                    ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 20),
        ),
      ),
    );
  }
}
