import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/API/media_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var mediaGallery = <Media>[].obs;
  var gallerycounter = 0.obs;
  var ismediaProcces = false.obs;
  var mediaUploadProcess = false.obs;

  var pageisactive = false.obs;
  late var tabController = Rx<TabController?>(null);
  var mediaList = <Media>[].obs;
  var galleryscrollcontroller = ScrollController().obs;

  var fetchFirstDeviceGalleryStatus = false.obs;
  var assets = <AssetEntity>[].obs;
  var memorymedia = <Media>[].obs;
  var thumbnailmemorymedia = <Media>[].obs;
  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    //Cihaz Galerisini çek
    if (!fetchFirstDeviceGalleryStatus.value) {
      _fetchAssets();
    }

    if (!pageisactive.value) {
      startingfunction();
      pageisactive.value = true;
    }

    galleryscrollcontroller.value.addListener(() {
      if (galleryscrollcontroller.value.position.pixels ==
          galleryscrollcontroller.value.position.maxScrollExtent) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        galleryfetch();
        log("dsa");
      }
    });

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    ).obs;
    tabController.value!.addListener(() {
      if (tabController.value!.indexIsChanging ||
          tabController.value!.index != tabController.value!.previousIndex) {
        if (tabController.value!.index == 0) {
          setstatefunction();
        }
        if (tabController.value!.index == 1) {
          setstatefunction();
        }
      }
    });
  }

  setstatefunction() {}

  Future<void> uploadmediafunction() async {
    if (mediaUploadProcess.value) {
      return;
    }

    mediaUploadProcess.value = true;
    setstatefunction();

    MediaAPI funct =
        MediaAPI(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response = await funct.upload(
      files: mediaList.map((media) => media.mediaXFile!).toList(),
      category: "-1",
    );

    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      mediaUploadProcess.value = false;
      setstatefunction();
      return;
    }

    mediaUploadProcess.value = false;

    mediaList.clear();
    setstatefunction();
    galleryfetch(reloadpage: true);
  }

  Future<void> startingfunction() async {
    await galleryfetch();
  }

  Future<void> galleryfetch({bool reloadpage = false}) async {
    if (ismediaProcces.value) {
      return;
    }

    if (reloadpage) {
      gallerycounter.value = 0;
    }
    ismediaProcces.value = true;
    MediaAPI f = MediaAPI(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response = await f.fetch(
      uyeID: currentUserAccounts.value.user.value.userID!,
      category: "",
      page: gallerycounter.value + 1,
    );

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ismediaProcces.value = false;
      return;
    }

    if (reloadpage) {
      mediaGallery.clear();
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      Map<String, dynamic> mediaInfo = response["icerik"][i];
      mediaGallery.add(
        Media(
          mediaID: mediaInfo["media_ID"],
          ownerID: mediaInfo["media_ownerID"],
          mediaType: mediaInfo["fotodosyatipi"],
          mediaTime: mediaInfo["media_time"],
          mediaURL: MediaURL(
            bigURL: Rx<String>(mediaInfo["fotoorijinalurl"]),
            normalURL: Rx<String>(mediaInfo["fotoufaklikurl"]),
            minURL: Rx<String>(mediaInfo["fotominnakurl"]),
          ),
        ),
      );
    }
    gallerycounter.value++;
    ismediaProcces.value = false;
    setstatefunction();
  }

  void _fetchAssets() async {
    if (fetchFirstDeviceGalleryStatus.value) {
      return;
    }
    fetchFirstDeviceGalleryStatus.value = true;
    assets.value = await PhotoManager.getAssetListRange(
      start: 0,
      end: 300,
    );

    for (AssetEntity element in assets) {
      // Original
      final bytes = await element.thumbnailDataWithOption(
        const ThumbnailOption(
          size: ThumbnailSize(600, 600),
          quality: 95,
        ),
      );

      //Thumbnail
      final thumbnailbytes = await element.thumbnailDataWithOption(
        const ThumbnailOption(
          size: ThumbnailSize(150, 150),
          quality: 80,
        ),
      );
      memorymedia.add(
        Media(
          mediaID: element.typeInt,
          mediaBytes: bytes,
          mediaURL: MediaURL(
            bigURL: Rx<String>("bigURL"),
            normalURL: Rx<String>("normalURL"),
            minURL: Rx<String>("minURL"),
          ),
        ),
      );

      thumbnailmemorymedia.add(
        Media(
          mediaID: element.typeInt,
          mediaBytes: thumbnailbytes,
          mediaURL: MediaURL(
            bigURL: Rx<String>("bigURL"),
            normalURL: Rx<String>("normalURL"),
            minURL: Rx<String>("minURL"),
          ),
        ),
      );
    }
    setstatefunction();
  }
}
