import 'package:armoyu/app/modules/pages/mainpage/mediaplayer_page/controllers/mediaplayer_controller.dart';
import 'package:armoyu/app/widgets/appbar_widget.dart';
import 'package:armoyu/app/widgets/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaplayerView extends StatelessWidget {
  const MediaplayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaplayerController());
    return Scaffold(
      appBar: AppbarWidget.custom(),
      body: controller.player.widget.value!,
      bottomNavigationBar: BottomnavigationBar.custom1(),
    );
  }
}
