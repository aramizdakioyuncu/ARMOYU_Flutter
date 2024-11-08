import 'package:ARMOYU/app/modules/Social/detail_post_page/controllers/postdetail_controller.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostdetailView extends StatelessWidget {
  const PostdetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controler = Get.put(PostdetailController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paylaşım', style: TextStyle(fontSize: 18)),
        toolbarHeight: 40,
      ),
      body: Obx(
        () => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {},
            ),
            controler.widget.value == null
                ? const SliverFillRemaining(
                    child: CupertinoActivityIndicator(),
                  )
                : SliverToBoxAdapter(
                    child: controler.widget.value,
                  ),
          ],
        ),
      ),
    );
  }
}
