import 'package:armoyu/app/modules/News/news_page/controllers/news_page_controller.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class NewsPageView extends StatelessWidget {
  const NewsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsPageController controller = Get.put(NewsPageController());
    return Scaffold(
      appBar: AppbarWidget.standart(
          title: controller.news.value!.newsTitle.toString(),
          actions: [
            IconButton(
              onPressed: () async {
                await SharePlus.instance.share(
                  ShareParams(
                    uri: Uri.parse(
                        'https://aramizdakioyuncu.com/haberler/oyun/${controller.news.value!.newsTitle}'),
                  ),
                );
              },
              icon: const Icon(Icons.share),
            ),
          ]),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await controller.fetchnewscontent();
            },
          ),
          SliverToBoxAdapter(
            child: CachedNetworkImage(
              width: ARMOYU.screenWidth,
              height: ARMOYU.screenHeight / 5,
              imageUrl: controller.news.value!.newsImage,
              fit: BoxFit.cover,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.news.value!.newsTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Obx(
            () => controller.newsfetchProcess.value
                ? const SliverFillRemaining(
                    child: CupertinoActivityIndicator(),
                  )
                : SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        controller.news.value!.newsContent.toString(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
