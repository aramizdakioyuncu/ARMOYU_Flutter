import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/modules/Utility/noconnectionpage/controllers/noconnection_controller.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnectionpageView extends StatelessWidget {
  const NoConnectionpageView({super.key});

  @override
  Widget build(BuildContext context) {
    final NoconnectionapageController controller =
        Get.put(NoconnectionapageController());

    return Scaffold(
      backgroundColor: ARMOYU.appbarColor,
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.isConnected.value
                  ? const Icon(Icons.signal_wifi_4_bar,
                      size: 80, color: Colors.red)
                  : const Icon(Icons.signal_wifi_off,
                      size: 80, color: Colors.red),
              const SizedBox(height: 20),
              controller.isConnected.value
                  ? const Text(
                      "İnternet Sınanıyor...",
                      style: TextStyle(fontSize: 18),
                    )
                  : const Text(
                      "İnternet Bağlantısı Yok!",
                      style: TextStyle(fontSize: 18),
                    ),
              const SizedBox(height: 20),
              CustomButtons.costum1(
                text: "Tekrar dene",
                onPressed: controller.checkInternetConnection2,
                loadingStatus: controller.connectionProcess.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
