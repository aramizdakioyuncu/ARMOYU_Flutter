import 'dart:io';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FilterItem {
  Color? color;
  Media? media;
  VoidCallback? onFilterSelected;
  bool? isImage;
  bool isSelected;
  bool loadingStatus = false;

  FilterItem({
    this.color,
    this.media,
    this.onFilterSelected,
    this.isImage = false,
    this.isSelected = false,
  });
  Widget filterWidget(
      BuildContext contex, PageController controller, int index) {
    if (media == null) {
      return GestureDetector(
        onTap: () {
          if (!isSelected) {
            controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
            return;
          }
          onFilterSelected!();
        },
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white,
                    width: 3.0,
                  ),
                )
              : null,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (color != null) {
      return GestureDetector(
        onTap: () {
          if (!isSelected) {
            controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
            return;
          }
          onFilterSelected!();
        },
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white,
                    width: 3.0,
                  ),
                )
              : null,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: media!.mediaURL.normalURL.value,
                  fit: BoxFit.cover,
                  color: color!.withOpacity(0.5),
                  colorBlendMode: BlendMode.hardLight,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
          return;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: FileImage(
                File(
                  media!.mediaURL.normalURL.value,
                ),
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
