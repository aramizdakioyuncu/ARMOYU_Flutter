import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorypublishController extends GetxController {
  final User currentUser;
  final String imageURL; // Gezdirilecek fotoğrafların listesi
  final int imageID; // Gezdirilecek fotoğrafların ID listesi
  StorypublishController({
    required this.currentUser,
    required this.imageURL,
    required this.imageID,
  });
  var isEveryonepublish = true.obs;

  var texts = <StoryText>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (kDebugMode) {
      print("ID $imageID");
      print("URL $imageURL");
    }
  }

  void addText(String newText) {
    texts.add(
      StoryText(
        text: newText,
        position: const Offset(50, 50),
        color: Rx(Colors.white),
      ),
    );
  }

  Widget colorOption(
      Rx<Color> color, Rx<Color> selectedColor, Function(Color) onSelect) {
    return GestureDetector(
      onTap: () {
        onSelect(color.value);
        selectedColor.refresh();
      },
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color.value,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor.value == color.value
                ? Colors.white
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  void updateText(StoryText storyText, String newText, Color newColor) {
    storyText.text = newText;
    storyText.color.value = newColor;
    texts.refresh();
  }

  void showEditDialog(
    BuildContext context,
    StorypublishController controller,
    StoryText storyText,
  ) {
    final TextEditingController textController =
        TextEditingController(text: storyText.text);

    var selectedColor = storyText.color;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Metni Düzenle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Renk seçici
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => colorOption(Rx(Colors.white), (selectedColor), (color) {
                    selectedColor.value = color;
                  }),
                ),
                Obx(
                  () => colorOption(Rx(Colors.red), (selectedColor), (color) {
                    selectedColor.value = color;
                  }),
                ),
                Obx(
                  () => colorOption(Rx(Colors.blue), (selectedColor), (color) {
                    selectedColor.value = color;
                  }),
                ),
                Obx(
                  () => colorOption(Rx(Colors.green), (selectedColor), (color) {
                    selectedColor.value = color;
                  }),
                ),
                Obx(
                  () =>
                      colorOption(Rx(Colors.yellow), (selectedColor), (color) {
                    selectedColor.value = color;
                  }),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateText(
                storyText,
                textController.text,
                selectedColor.value,
              );
              Get.back();
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  Future<void> publishstory(String storyURL, bool isEveryonepublish) async {
    ServiceResult response = await API.service.storyServices.addstory(
      imageURL: storyURL,
      isEveryonePublish: isEveryonepublish,
    );
    if (!response.status) {
      log(response.description);
      return;
    }

    Get.back();
    Get.back();
  }
}

class StoryText {
  String text;
  Offset position;
  Rx<Color> color;

  StoryText({required this.text, required this.position, required this.color});
}
