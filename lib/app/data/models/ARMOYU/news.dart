import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class News {
  int newsID;
  String newsTitle;
  String newsContent;
  String newssummary;
  String newsImage;
  String author;
  String authoravatar;
  int newsViews;

  News({
    required this.newsID,
    required this.newsTitle,
    required this.newsContent,
    required this.newssummary,
    required this.newsImage,
    required this.author,
    required this.authoravatar,
    required this.newsViews,
  });

  // Convert News instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'newsID': newsID,
      'newsTitle': newsTitle,
      'newsContent': newsContent,
      'newssummary': newssummary,
      'newsImage': newsImage,
      'author': author,
      'authoravatar': authoravatar,
      'newsViews': newsViews,
    };
  }

  // Convert JSON to News instance
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsID: json['newsID'],
      newsTitle: json['newsTitle'],
      newsContent: json['newsContent'],
      newssummary: json['newssummary'],
      newsImage: json['newsImage'],
      author: json['author'],
      authoravatar: json['authoravatar'],
      newsViews: json['newsViews'],
    );
  }

  Widget newsListWidget(context, {required User currentUser}) {
    return SizedBox(
      width: ARMOYU.screenWidth,
      child: Material(
        color: Get.theme.cardColor,
        child: InkWell(
          onTap: () {
            log("sa");
            Get.toNamed("/news/detail", arguments: {
              "user": currentUser,
              "news": this,
            });
          },
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                          authoravatar,
                        ),
                        radius: 14,
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        author,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.visibility,
                              size: 16,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              newsViews.toString(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                newsImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: newsImage,
                        height: 200,
                        width: ARMOYU.screenWidth,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.car_crash,
                        size: 50,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CustomText.costum1(newsTitle,
                            weight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        newssummary,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
