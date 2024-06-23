import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/News/news_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  Widget newsListWidget(context, {required User currentUser}) {
    return SizedBox(
      width: ARMOYU.screenWidth,
      child: Material(
        color: ARMOYU.appbarColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsPage(
                  news: this,
                  currentUser: currentUser,
                ),
              ),
            );
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
                      ),
                      const SizedBox(width: 10),
                      Text(
                        author,
                        style: TextStyle(color: ARMOYU.color),
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
                              style: TextStyle(color: ARMOYU.color),
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
                        style: TextStyle(color: ARMOYU.textColor),
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
