import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:ARMOYU/app/widgets/Skeletons/cards_skeleton.dart';
import 'package:ARMOYU/app/widgets/cards/cards_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCards extends StatelessWidget {
  final String title;
  final List<Map<String, String>> content;
  final Icon icon;
  final Color effectcolor;
  final bool firstFetch;

  const CustomCards({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.effectcolor,
    required this.firstFetch,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CardsController(
        content: content,
        effectcolor: effectcolor,
        firstFetch: firstFetch,
        icon: icon,
        title: title,
      ),
      tag: DateTime.now().microsecondsSinceEpoch.toString() + title,
    );

    return Obx(
      () => controller.xcontent.value == null
          ? SkeletonCustomCards(count: 5, icon: controller.xicon.value!)
          : SizedBox(
              height: 220,
              child: ListView.separated(
                controller: controller.xscrollController.value,
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                scrollDirection: Axis.horizontal,
                itemCount: controller.morefetchProcces.value
                    ? controller.xcontent.value!.length + 1
                    : controller.xcontent.value!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (controller.xcontent.value!.length == index) {
                    return const SizedBox(
                      width: 150,
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  Map<String, String> cardData =
                      controller.xcontent.value![index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      PageFunctions functions = PageFunctions();
                      functions.pushProfilePage(
                        context,
                        User(
                          userID: int.parse(cardData["userID"].toString()),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          image: CachedNetworkImageProvider(
                            cardData["image"]!,
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              controller.xeffectcolor.value!,
                              Colors.transparent,
                              Colors.black,
                            ],
                            stops: const [0.1, 0.8, 1],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          // alignment: Alignment.bottomCenter,
                          children: [
                            const SizedBox(
                              height: 0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (index + 1).toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(7, 0, 7, 7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      cardData["displayname"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        controller.xicon.value!,
                                        const SizedBox(width: 5),
                                        Text(
                                          cardData["score"].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 20),
              ),
            ),
    );
  }
}
