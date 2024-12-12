import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/modules/utils/startingpage/controllers/startingpage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartingpageView extends StatelessWidget {
  const StartingpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final StartingpageController controller = Get.put(StartingpageController());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/armoyu512.png",
              width: ARMOYU.screenWidth / 3,
            ),
            Obx(
              () => Text(
                controller.connectionstatus.value,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
