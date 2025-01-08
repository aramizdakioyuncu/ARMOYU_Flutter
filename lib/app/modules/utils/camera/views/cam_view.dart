import 'dart:developer';
import 'dart:io';
import 'package:ARMOYU/app/modules/utils/camera/controllers/cam_controller.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CamView extends StatelessWidget {
  const CamView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CamController>();

    return PopScope(
      canPop: false,
      child: Obx(
        () => Scaffold(
          body: FutureBuilder<void>(
            future: controller.initializeControllerFuture.value,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Obx(
                          () => SizedBox(
                            height: Get.height,
                            width: Get.width,
                            child: controller.viewMedia.value == null
                                ? controller.filterColor.value != null
                                    ? controller.cameraController.value == null
                                        ? null
                                        : FittedBox(
                                            fit: BoxFit.cover,
                                            child: SizedBox(
                                              width: controller
                                                  .cameraController
                                                  .value!
                                                  .value
                                                  .previewSize!
                                                  .height,
                                              height: controller
                                                  .cameraController
                                                  .value!
                                                  .value
                                                  .previewSize!
                                                  .width,
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  controller.filterColor.value!
                                                      .withOpacity(
                                                    0.5,
                                                  ),
                                                  BlendMode.color,
                                                ),
                                                child: CameraPreview(
                                                  controller
                                                      .cameraController.value!,
                                                ),
                                              ),
                                            ),
                                          )
                                    : GestureDetector(
                                        onDoubleTap: () =>
                                            controller.changeCamera(),
                                        onScaleUpdate: (details) {
                                          double newScale;
                                          log(details.scale.toString());

                                          if (details.scale < 1) {
                                            newScale =
                                                controller.currentZoom - 0.04;
                                          } else {
                                            newScale =
                                                controller.currentZoom + 0.04;
                                          }

                                          log(newScale.toString());

                                          if (controller.maxZoom!.value <
                                              newScale) {
                                            controller.currentZoom =
                                                controller.maxZoom!.value;
                                            controller.cameraController.value!
                                                .setZoomLevel(
                                                    controller.currentZoom);
                                            return;
                                          }
                                          if (controller.minZoom!.value >
                                              newScale) {
                                            controller.currentZoom =
                                                controller.minZoom!.value;
                                            controller.cameraController.value!
                                                .setZoomLevel(
                                                    controller.currentZoom);
                                            return;
                                          }

                                          controller.currentZoom = newScale;
                                          controller.cameraController.value!
                                              .setZoomLevel(
                                                  controller.currentZoom);
                                        },
                                        child:
                                            controller.cameraController.value ==
                                                    null
                                                ? null
                                                : FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: SizedBox(
                                                      width: controller
                                                          .cameraController
                                                          .value!
                                                          .value
                                                          .previewSize!
                                                          .height,
                                                      height: controller
                                                          .cameraController
                                                          .value!
                                                          .value
                                                          .previewSize!
                                                          .width,
                                                      child: CameraPreview(
                                                        controller
                                                            .cameraController
                                                            .value!,
                                                      ),
                                                    ),
                                                  ),
                                      )
                                : Image.file(
                                    File(
                                      controller.viewMedia.value!,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: controller.canPop.value,
                            child: Positioned(
                              top: 40,
                              left: 10,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context, controller.media);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: controller.viewMedia.value == null,
                            child: Positioned(
                              top: 40,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: ARMOYU.cameras!.length > 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          child: InkWell(
                                            onTap: controller.changeCamera,
                                            child: const Icon(
                                              Icons.change_circle,
                                              size: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: InkWell(
                                          onTap: () {
                                            controller.changeflash();
                                          },
                                          child: Icon(
                                            controller.flashIcon.value,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                            controller.user.value!.avatar!
                                                .mediaURL.normalURL.value,
                                          ),
                                          radius: 12,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                            controller.user.value!.avatar!
                                                .mediaURL.normalURL.value,
                                          ),
                                          radius: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: controller.viewMedia.value != null &&
                                !controller
                                    .camfilter[controller.filterpage.value]
                                    .loadingStatus,
                            child: Positioned(
                              bottom: 10,
                              left: 10,
                              child: CustomButtons.costum2(
                                onPressed: () => controller.saveMedia(),
                                text: "Kaydet",
                                icon: const Icon(
                                  Icons.save_alt_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                loadingStatus:
                                    controller.savemediaProcess.value,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.cameraController.value == null
                              ? Container()
                              : Positioned(
                                  bottom: 60,
                                  width: Get.width,
                                  child: SizedBox(
                                    height: 70,
                                    child: PageView.builder(
                                      controller:
                                          controller.camfiltercontroller.value,
                                      physics: controller
                                              .takePictureProcess.value
                                          ? const NeverScrollableScrollPhysics()
                                          : const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.camfilter.length,
                                      onPageChanged: (value) {
                                        controller.filterpage.value = value;
                                        controller.camfilter[value].isSelected =
                                            true;

                                        try {
                                          controller.camfilter[value - 1]
                                              .isSelected = false;
                                        } catch (e) {
                                          log(e.toString());
                                        }
                                        try {
                                          controller.camfilter[value + 1]
                                              .isSelected = false;
                                        } catch (e) {
                                          log(e.toString());
                                        }

                                        if (controller.camfilter[value].color !=
                                            null) {
                                          controller.filterColor.value =
                                              controller.camfilter[value].color;
                                        } else {
                                          controller.filterColor.value = null;
                                        }

                                        if (controller
                                                .camfilter[value].isImage! &&
                                            controller.camfilter[value].media !=
                                                null) {
                                          controller.viewMedia.value =
                                              controller.camfilter[value].media!
                                                  .mediaURL.normalURL.value;
                                        } else {
                                          controller.viewMedia.value = null;
                                        }
                                        controller.camfilter.refresh();
                                        controller.filterpage.refresh();
                                        controller.viewMedia.refresh();
                                      },
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            controller.filterpage.value) {
                                          controller.camfilter[index]
                                              .isSelected = true;
                                        }
                                        return Center(
                                          child: controller.camfilter[index]
                                              .filterWidget(
                                            context,
                                            controller
                                                .camfiltercontroller.value,
                                            index,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
