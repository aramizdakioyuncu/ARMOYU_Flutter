import 'dart:developer';

import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/modules/Social/share_post_page/controllers/postshare_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PostshareView extends StatelessWidget {
  const PostshareView({super.key});

  @override
  Widget build(BuildContext context) {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//

    final controller = Get.put(PostshareController());
    return Scaffold(
      appBar: AppBar(
        title: Text(SocialKeys.socialShare.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => Media.mediaList(
                  controller.media,
                  big: true,
                  editable: true,
                  currentUser: findCurrentAccountController
                      .currentUserAccounts.value.user.value,
                ),
              ),
              SizedBox(
                width: Get.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => controller.userLocation.value == null
                            ? Container()
                            : Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomButtons.costum2(
                                      text: controller.userLocation.value,
                                      icon: const Icon(Icons.location_on),
                                      onPressed: () {},
                                    ),
                                  ),
                                  Positioned(
                                    right: 12,
                                    top: 12,
                                    child: InkWell(
                                      onTap: () {
                                        controller.userLocation.value = null;
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => CustomTextfields.mentionTextFiled(
                  key: controller.key,
                  minLines: 3,
                  currentUser: findCurrentAccountController
                      .currentUserAccounts.value.user.value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        dynamic aa = await controller.determinePosition();
                        log(aa.toString());

                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);

                        await placemarkFromCoordinates(
                                position.latitude, position.longitude)
                            .then((List<Placemark> placemarks) {
                          Placemark place = placemarks[0];
                          controller.userLocation.value =
                              place.subAdministrativeArea.toString();
                          ARMOYUWidget.toastNotification(
                              "${place.street}, ${place.subLocality} ,${place.subAdministrativeArea}, ${place.postalCode}");
                        }).catchError((e) {
                          debugPrint(e);
                        });
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        controller.key.value.currentState!.controller!.text +=
                            "@";
                      },
                      icon: const Icon(
                        Icons.person_2,
                        color: Colors.amber,
                      ),
                    ),
                    const Spacer(),
                    if (ARMOYU.cameras!.isNotEmpty)
                      IconButton(
                        onPressed: () async {
                          final List<Media> photo =
                              await Get.toNamed("/camera", arguments: {
                            "canPop": true,
                          });

                          for (var element in photo) {
                            log(element.mediaURL.minURL.value);
                          }
                          controller.media += photo;
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.deepPurple,
                        ),
                      ),
                    if (ARMOYU.cameras!.isNotEmpty) const Spacer(),
                    IconButton(
                      onPressed: () {
                        controller.key.value.currentState!.controller!.text +=
                            "#";
                      },
                      icon: const Icon(
                        Icons.numbers_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Obx(
                      () => CustomButtons.costum1(
                        text: CommonKeys.share.tr,
                        onPressed: controller.sharePost,
                        loadingStatus: controller.postshareProccess,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text(controller.postsharetext.value.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
