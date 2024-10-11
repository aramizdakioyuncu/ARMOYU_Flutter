import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/News/list_news_page/controllers/list_news_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListNewsView extends StatelessWidget {
  const ListNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ListNewsController controller = Get.put(ListNewsController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.backgroundcolor,
        appBar: AppBar(
          title: const Text('Haberler'),
        ),
        body: Obx(
          () => CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await controller.getnewslist();
                },
              ),
              controller.newsList.isEmpty
                  ? const SliverFillRemaining(
                      child: CupertinoActivityIndicator(),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index.isEven) {
                            return controller.widgetnews(context, index);
                          }
                          // Separator
                          return Column(
                            children: [
                              Container(color: ARMOYU.bodyColor, height: 1),
                              const SizedBox(height: 2),
                              Container(color: ARMOYU.bodyColor, height: 1),
                            ],
                          );
                        },
                        childCount: controller.newsList.length,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
