import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/News/news_page/controllers/news_page_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class NewsPageView extends StatelessWidget {
  const NewsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsPageController controller = Get.put(NewsPageController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        appBar: AppBar(
          title: Text(controller.news.value!.newsTitle.toString()),
          backgroundColor: ARMOYU.appbarColor,
          actions: [
            IconButton(
              onPressed: () {
                controller.fetchnewscontent();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                width: ARMOYU.screenWidth,
                height: ARMOYU.screenHeight / 5,
                imageUrl: controller.news.value!.newsImage,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.news.value!.newsTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Obx(
                () => controller.newsfetchProcess.value
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: controller.news.value!.newsContent,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
