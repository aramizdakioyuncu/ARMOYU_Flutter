import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/call_chat_page/views/chatcall_page.dart';
import 'package:ARMOYU/app/modules/pages/chatpage/detail_chat_page/controllers/chatdetail_controller.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChatDetailView extends StatefulWidget {
  const ChatDetailView({super.key});

  @override
  State<ChatDetailView> createState() => _ChatDetailPage();
}

class _ChatDetailPage extends State<ChatDetailView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final controller = Get.put(
      ChatdetailController(),
    );

    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        backgroundColor: ARMOYU.backgroundcolor,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.costum1(
              controller.chat.value!.user.displayName!,
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
                                .toString(),
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
                    PageFunctions functions = PageFunctions(
                      currentUserAccounts:
                          controller.currentUserAccounts.value!,
                    );
                    functions.pushProfilePage(
                      context,
                      User(userID: controller.chat.value!.user.userID!),
                      ScrollController(),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl:
                        controller.chat.value!.user.avatar!.mediaURL.minURL,
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
              color: ARMOYU.appbottomColor,
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
                              ARMOYU.bodyColor,
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
                                color: ARMOYU.textbackColor,
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
                                decoration: const InputDecoration(
                                  hintText: 'Mesaj yaz',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
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
