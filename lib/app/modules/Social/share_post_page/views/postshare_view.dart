import 'package:armoyu/app/modules/Social/share_post_page/controllers/postshare_controller.dart';
import 'package:armoyu/app/translations/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostshareView extends StatelessWidget {
  const PostshareView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostshareController());
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(SocialKeys.socialShare.tr),
      ),
      body: controller.createPostWidget.widget.value,
    );
  }
}
