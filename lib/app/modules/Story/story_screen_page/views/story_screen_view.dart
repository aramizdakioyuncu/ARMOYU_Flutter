import 'dart:developer';
import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/story.dart';
import 'package:ARMOYU/app/modules/Story/story_screen_page/controllers/story_screen_controller.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryScreenView extends StatelessWidget {
  const StoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoryScreenController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  if (controller
                          .storyList
                          .value[controller.storyIndex.value!]
                          .story![controller.initialStoryIndex.value]
                          .ownerusername ==
                      controller.currentUser.value!.userName!.value) {
                    controller.stopAnimation();

                    Get.toNamed("/gallery");
                  }
                },
                child: Obx(
                  () => Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        image: CachedNetworkImageProvider(
                          controller
                              .storyList
                              .value[controller.storyIndex.value!]
                              .story![controller.initialStoryIndex.value]
                              .owneravatar,
                          errorListener: (p0) =>
                              const CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: controller
                                  .storyList
                                  .value[controller.storyIndex.value!]
                                  .story![controller.initialStoryIndex.value]
                                  .ownerusername ==
                              controller.currentUser.value!.userName!.value
                          ? Container(
                              height: 12,
                              width: 12,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(100, 100),
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 10,
                                color: Colors.blue,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Obx(
                () => Text(
                  controller
                              .storyList
                              .value[controller.storyIndex.value!]
                              .story![controller.initialStoryIndex.value]
                              .ownerusername ==
                          controller.currentUser.value!.userName!.value
                      ? "Hikayen"
                      : controller.storyList.value[controller.storyIndex.value!]
                          .owner.userName!.value,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(width: 5),
              Obx(
                () => Text(
                  controller.storyList.value[controller.storyIndex.value!]
                      .story![controller.initialStoryIndex.value].time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz_outlined),
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Obx(
          () => PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.storyList.value.length,
            controller: controller.pageControllerStory.value,
            onPageChanged: (value) {
              controller.storyIndex.value = value;
              controller.containerWidth.value = 0;
              controller.containerWidthValue.value = 0;
            },
            itemBuilder: (context, indexstoryList) {
              return Column(
                children: [
                  SizedBox(
                    height: 5,
                    width: Get.width,
                    child: Row(
                      children: List.generate(
                        controller
                            .storyList.value[indexstoryList].story!.length,
                        (index) {
                          if (index < controller.initialStoryIndex.value) {
                            return Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: SizedBox(
                                  width: (Get.width -
                                          2 *
                                              controller
                                                  .storyList
                                                  .value[indexstoryList]
                                                  .story!
                                                  .length) /
                                      controller.storyList.value[indexstoryList]
                                          .story!.length,
                                  child: LinearProgressIndicator(
                                    value: 1,
                                    backgroundColor: Colors.grey,
                                    color: Colors.white,
                                    minHeight: 2,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (index == controller.initialStoryIndex.value) {
                            return Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: SizedBox(
                                  width: (Get.width -
                                          2 *
                                              controller
                                                  .storyList
                                                  .value[indexstoryList]
                                                  .story!
                                                  .length) /
                                      controller.storyList.value[indexstoryList]
                                          .story!.length,
                                  child: LinearProgressIndicator(
                                    value: controller.containerWidthValue.value,
                                    backgroundColor: Colors.grey,
                                    color: Colors.white,
                                    minHeight: 2,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Obx(
                            () => Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: SizedBox(
                                width: (Get.width -
                                        2 *
                                            controller
                                                .storyList
                                                .value[indexstoryList]
                                                .story!
                                                .length) /
                                    controller.storyList.value[indexstoryList]
                                        .story!.length,
                                child: LinearProgressIndicator(
                                  value: 0,
                                  backgroundColor: Colors.grey,
                                  color: Colors.white,
                                  minHeight: 2,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: controller.pageController.value,
                      itemCount: controller
                          .storyList.value[indexstoryList].story!.length,
                      itemBuilder: (context, index) {
                        if (controller.storyList.value[indexstoryList]
                                .story![index].isView ==
                            0) {
                          // storyview(
                          //   controller.storyList[indexstoryList].story![index],
                          // );
                        }

                        return Obx(
                          () => Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onLongPressEnd: (details) {
                                    controller.startAnimation();
                                  },
                                  onLongPressStart: (_) {
                                    controller.stopAnimation();
                                  },
                                  onPanUpdate: (details) {
                                    log(details.globalPosition.toString());
                                  },

                                  onTap: () {
                                    controller.onTapeventStory();
                                  },
                                  // onTapUp: (details) {
                                  //   _startAnimation();
                                  // },
                                  onVerticalDragUpdate: (details) {
                                    if (controller
                                            .storyList
                                            .value[indexstoryList]
                                            .story![index]
                                            .ownerID !=
                                        controller.currentUser.value!.userID) {
                                      return;
                                    }
                                    if (details.delta.dy > 0) {
                                      //Aşağı kaydırma
                                    } else {
                                      //Yukarı kaydırma
                                      controller.viewmystoryviewlist();
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      InteractiveViewer(
                                        scaleEnabled: false,
                                        child: Center(
                                          child: Hero(
                                            tag: 'imageTag',
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                  .storyList
                                                  .value[indexstoryList]
                                                  .story![index]
                                                  .media,
                                              height: ARMOYU.screenHeight / 1,
                                              width: ARMOYU.screenHeight / 1,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onDoubleTap: () {
                                              // Çift tıklayınca yakınlaştırmayı sıfırla
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (controller.storyList.value[indexstoryList]
                                      .story![index].ownerusername !=
                                  controller.currentUser.value!.userName!.value)
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                          controller.currentUser.value!.avatar!
                                              .mediaURL.minURL.value,
                                        ),
                                        radius: 20,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(5),
                                        height: 55,
                                        child: Center(
                                          child: Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade800,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: const TextField(
                                              // controller: controller_message,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                              decoration: InputDecoration(
                                                hintText: 'Mesaj yaz',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: IconButton(
                                              onPressed: () async {
                                                if (controller
                                                        .storyList
                                                        .value[indexstoryList]
                                                        .story![index]
                                                        .isLike ==
                                                    0) {
                                                  FunctionsStory funct =
                                                      FunctionsStory(
                                                    currentUser: controller
                                                        .currentUser.value!,
                                                  );
                                                  Map<String, dynamic>
                                                      response =
                                                      await funct.like(controller
                                                          .storyList
                                                          .value[indexstoryList]
                                                          .story![index]
                                                          .storyID);
                                                  if (response["durum"] == 0) {
                                                    log(response["aciklama"]);
                                                    return;
                                                  }

                                                  controller
                                                      .storyList
                                                      .value[indexstoryList]
                                                      .story![index]
                                                      .isLike = 1;

                                                  // setstatefunction();
                                                } else {
                                                  FunctionsStory funct =
                                                      FunctionsStory(
                                                    currentUser: controller
                                                        .currentUser.value!,
                                                  );
                                                  Map<String, dynamic>
                                                      response = await funct
                                                          .likeremove(controller
                                                              .storyList
                                                              .value[
                                                                  indexstoryList]
                                                              .story![index]
                                                              .storyID);
                                                  if (response["durum"] == 0) {
                                                    log(response["aciklama"]);
                                                    return;
                                                  }

                                                  // setState(() {
                                                  controller
                                                      .storyList
                                                      .value[indexstoryList]
                                                      .story![index]
                                                      .isLike = 0;
                                                  // });
                                                }
                                              },
                                              icon: controller
                                                          .storyList
                                                          .value[indexstoryList]
                                                          .story![index]
                                                          .isLike ==
                                                      1
                                                  ? const Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(
                                                      Icons.favorite_outline,
                                                      color: Colors.grey,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          controller.viewmystoryviewlist();
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(
                                              Icons.more_horiz_rounded,
                                            ),
                                            Text(
                                              "Daha fazla",
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
