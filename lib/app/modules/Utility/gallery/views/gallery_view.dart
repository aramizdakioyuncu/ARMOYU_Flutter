import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/modules/Utility/gallery/controllers/gallery_controller.dart';
import 'package:ARMOYU/app/modules/Utility/newphotoviewer.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    var currentUser =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    final controller = Get.put(GalleryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hikaye Gönder'),
      ),
      body: Obx(
        () => Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.white,
              controller: controller.tabController.value,
              isScrollable: false,
              indicatorColor: Colors.blue,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: CustomText.costum1('ARMOYU Cloud', size: 15.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: CustomText.costum1('Telefon', size: 15.0),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController.value,
                children: [
                  RefreshIndicator(
                    onRefresh: () async =>
                        controller.galleryfetch(reloadpage: true),
                    child: SingleChildScrollView(
                      controller: controller.galleryscrollcontroller.value,
                      child: Column(
                        children: [
                          Media.mediaList(
                            controller.mediaList,
                            big: false,
                            currentUser: currentUser,
                          ),
                          SizedBox(
                            height: 150,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: CustomButtons.costum1(
                                    text: "Yükle",
                                    enabled: controller.mediaList.isNotEmpty,
                                    onPressed: () async =>
                                        await controller.uploadmediafunction(),
                                    loadingStatus:
                                        controller.mediaUploadProcess,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GridView.builder(
                            controller: ScrollController(),
                            itemCount: controller.mediaGallery.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return controller.mediaGallery[index]
                                  .mediaGallery(
                                context: context,
                                index: index,
                                medialist: controller.mediaGallery,
                                storyShare: true,
                                setstatefunction: controller.setstatefunction,
                                currentUser: currentUser,
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Her satırda 3 görsel
                              crossAxisSpacing: 5.0, // Yatayda boşluk
                              mainAxisSpacing: 5.0, // Dikeyde boşluk
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Her satırda 3 görsel
                      crossAxisSpacing: 5.0, // Yatayda boşluk
                      mainAxisSpacing: 5.0, // Dikeyde boşluk
                    ),
                    itemCount: controller.thumbnailmemorymedia.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaViewer(
                                currentUser: currentUser,
                                isMemory: true,
                                media: controller.memorymedia,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Image.memory(
                          controller.thumbnailmemorymedia[index].mediaBytes!,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
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
