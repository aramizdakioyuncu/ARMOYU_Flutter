import 'package:armoyu/app/modules/pages/mainpage/reels_page/controllers/reels_controller.dart';
import 'package:armoyu/app/widgets/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    final reelsController = Get.put(MainReelsController());
    return Scaffold(
      body: reelsController.reelsWidgetBundle.widget.value,
      bottomNavigationBar: BottomnavigationBar.custom1(),
    );
  }
}
