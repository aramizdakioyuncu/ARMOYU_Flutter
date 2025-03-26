import 'package:armoyu/app/modules/News/list_news_page/controllers/list_news_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListNewsView extends StatelessWidget {
  const ListNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ListNewsController controller = Get.put(ListNewsController());

    return Scaffold(
      appBar: AppbarWidget.standart(title: DrawerKeys.drawerNews.tr),
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
                            Container(color: Get.theme.cardColor, height: 1),
                            const SizedBox(height: 2),
                            Container(color: Get.theme.cardColor, height: 1),
                          ],
                        );
                      },
                      childCount: controller.newsList.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
