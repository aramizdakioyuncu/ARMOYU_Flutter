import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/call_chat_page/views/chatcall_page.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/detail_chat_page/controllers/chatdetail_controller.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChatDetailView extends StatelessWidget {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatdetailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.costum1(
              controller.chat.value!.user.displayName!.value,
              size: 17,
              weight: FontWeight.bold,
            ),
            Row(
              children: [
                controller.chat.value!.user.lastloginv2 == null
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(width: 20),
                      )
                    : Text(
                        controller.chat.value!.user.lastloginv2 == null
                            ? ""
                            : controller.chat.value!.user.lastloginv2
                                .toString()
                                .toString()
                                .replaceAll('Saniye', CommonKeys.second.tr)
                                .replaceAll('Dakika', CommonKeys.minute.tr)
                                .replaceAll('Saat', CommonKeys.hour.tr)
                                .replaceAll('Gün', CommonKeys.day.tr)
                                .replaceAll('Ay', CommonKeys.month.tr)
                                .replaceAll('Yıl', CommonKeys.year.tr)
                                .replaceAll('Çevrimiçi', CommonKeys.online.tr)
                                .replaceAll(
                                    'Çevrimdışı', CommonKeys.offline.tr),
                        style: TextStyle(
                          fontSize: 10,
                          color: controller.chat.value!.user.lastloginv2
                                      .toString() ==
                                  "Çevrimiçi"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
              ],
            ),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: GestureDetector(
                  onTap: () {
                    PageFunctions functions = PageFunctions();
                    functions.pushProfilePage(
                      context,
                      User(userID: controller.chat.value!.user.userID!),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: controller
                        .chat.value!.user.avatar!.mediaURL.minURL.value,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatCallPage(
                    user: controller.chat.value!.user,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.getchat();
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/chat_wallpaper.jpg"),
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
        child: Column(
          children: [
            Obx(
              () => Expanded(child: controller.chatListView(context)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Get.theme.scaffoldBackgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        child: IconButton(
                          icon: const Icon(Icons.attach_file_sharp),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Get.theme.cardColor,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Obx(
                      () => Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Get.theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextField(
                                controller: controller.messageController.value,
                                minLines: 1,
                                maxLines: 5,
                                cursorColor: Colors.blue,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  hintText: ChatKeys.chatwritemessage.tr,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      onPressed: () async => controller.sendMessage(),
                      icon: const Icon(
                        Icons.send,
                        size: 16,
                        color: Colors.white,
                      ),
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
