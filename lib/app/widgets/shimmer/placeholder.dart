import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

enum ContentLineType {
  twoLines,
  threeLines,
}

class ShimmerPlaceholder {
  static Widget titlePlaceholder({double? width}) {
    return Shimmer.fromColors(
      baseColor: Get.theme.disabledColor,
      highlightColor: Get.theme.highlightColor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        width: width,
        height: 12.0,
      ),
    );
  }

  static Widget bannerPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200.0,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
    );
  }

  static Widget listTilePlaceholder({Icon? trailingIcon}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: const CircleAvatar(),
      ),
      title: Shimmer.fromColors(
        baseColor: Get.theme.disabledColor,
        highlightColor: Get.theme.highlightColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black,
          ),
          height: 15,
        ),
      ),
      subtitle: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Get.theme.disabledColor,
            highlightColor: Get.theme.highlightColor,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black,
              ),
              height: 10,
              width: 100,
            ),
          ),
        ],
      ),
      trailing: trailingIcon == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(1.0),
              child: Shimmer.fromColors(
                baseColor: Get.theme.disabledColor,
                highlightColor: Get.theme.highlightColor,
                child: trailingIcon,
              ),
            ),
    );
  }

  static Widget contentPlaceholder({required ContentLineType lineType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96.0,
            height: 72.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8.0),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8.0),
                  ),
                Container(
                  width: 100.0,
                  height: 10.0,
                  color: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
