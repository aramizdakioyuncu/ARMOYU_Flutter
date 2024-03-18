import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/News/news_page.dart';
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

  Widget newsListWidget(context) {
    return Container(
      width: ARMOYU.screenWidth,
      padding: const EdgeInsets.all(2),
      child: Material(
        color: ARMOYU.appbarColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsPage(news: this),
              ),
            );
          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(newsTitle),
                      const SizedBox(height: 10),
                      Text(
                        newssummary,
                        style: TextStyle(color: ARMOYU.textColor),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            author,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
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
  }
}
