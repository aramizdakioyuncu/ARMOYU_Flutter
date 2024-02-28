// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonCustomCards extends StatefulWidget {
  // final ScrollController controller;
  final int count;
  final Icon icon;

  const SkeletonCustomCards({
    super.key,
    // required this.controller,
    required this.count,
    required this.icon,
  });

  @override
  State<SkeletonCustomCards> createState() => _SkeletonCustomCards();
}

class _SkeletonCustomCards extends State<SkeletonCustomCards> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        scrollDirection: Axis.horizontal,
        itemCount: widget.count,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {},
            child: SizedBox(
              width: 150,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SkeletonAvatar(
                            style:
                                SkeletonAvatarStyle(width: 600, height: 140)),
                        SizedBox(height: 10),
                        SkeletonLine(
                          style: SkeletonLineStyle(width: 600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.icon,
                            const SizedBox(width: 5),
                            SkeletonLine(
                              style: SkeletonLineStyle(width: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
      ),
    );
  }
}
