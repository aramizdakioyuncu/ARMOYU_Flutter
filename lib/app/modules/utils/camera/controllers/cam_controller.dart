import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Camera/camfilter.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/media_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CamController extends GetxController {
  var camScreen = 0.obs;
  var filterpage = 0.obs;
  var takePictureProcess = false.obs;

  // Color? filterColor;
  // String? viewMedia;

  Rxn<Color> filterColor = Rxn<Color>();
  Rxn<String> viewMedia = Rxn<String>();

  double currentZoom = 1;

  var flashMode = FlashMode.off.obs;
  var flashIcon = Icons.flash_off_rounded.obs;
  var imagePath = <XFile>[].obs;
  var media = <Media>[].obs;
  var camfilter = <FilterItem>[].obs;

  var camfiltercontroller = PageController().obs;

  var initializeControllerFuture = Rxn<Future<void>>();

  Rx<double>? maxZoom;
  Rx<double>? minZoom;

  var savemediaProcess = false.obs;

  var isfirstProcess = true.obs;

  var user = Rxn<User>();

  var canPop = false.obs;

  var cameraController = Rxn<CameraController>(null);

  void startcamservice() {
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    user.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;
    canPop.value = false;
    if (Get.arguments != null) {
      Map<String, dynamic> arguments = Get.arguments;
      if (arguments['canPop'] != null) {
        canPop.value = arguments['canPop'];
      }
    }

    //kamera Ayarlamaları
    initializeControllerFuture.value = initializeCamera();
    //kamera Ayarlamaları

    camfiltercontroller.value = PageController(
      viewportFraction: 0.2,
      initialPage: filterpage.value,
      keepPage: true,
    );

    if (isfirstProcess.value) {
      camfilter.add(
        FilterItem(
          onFilterSelected: () => takePicture(),
        ),
      );
      camfilter.add(
        FilterItem(
          color: Colors.white,
          onFilterSelected: () => takePicture(color: Colors.white),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              normalURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              minURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
            ),
          ),
        ),
      );

      camfilter.add(
        FilterItem(
          color: Colors.grey,
          onFilterSelected: () => takePicture(color: Colors.grey),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              normalURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              minURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
            ),
          ),
        ),
      );
      camfilter.add(
        FilterItem(
          color: Colors.red,
          onFilterSelected: () => takePicture(color: Colors.red),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              normalURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              minURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
            ),
          ),
        ),
      );
      camfilter.add(
        FilterItem(
          color: Colors.yellow,
          onFilterSelected: () => takePicture(color: Colors.yellow),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              normalURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              minURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
            ),
          ),
        ),
      );
      camfilter.add(
        FilterItem(
          color: Colors.green,
          onFilterSelected: () => takePicture(color: Colors.green),
          media: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              normalURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
              minURL: Rx<String>(
                  "https://fotolifeakademi.com/uploads/2020/12/portre-fotografciligi-kursu.webp"),
            ),
          ),
        ),
      );
      isfirstProcess.value = false;
    }
  }

  void stopcamservice() {
    if (cameraController.value != null) {
      cameraController.value!.dispose();
      cameraController.value = null;
    }
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        cameraController.value = CameraController(
          cameras[camScreen.value],
          ResolutionPreset.high,
          enableAudio: true,
        );
        await cameraController.value!.initialize();

        maxZoom = (await cameraController.value!.getMaxZoomLevel()).obs;
        minZoom = (await cameraController.value!.getMinZoomLevel()).obs;

        cameraController.value!.setZoomLevel(currentZoom);
      } else {
        // throw CameraException('No cameras available');
      }
    } on CameraException catch (e) {
      debugPrint('Error: $e');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void takePicture({Color? color}) async {
    cameraController.value!.setFlashMode(flashMode.value);
    if (takePictureProcess.value) {
      return;
    }
    takePictureProcess.value = true;
    try {
      final XFile picture = await cameraController.value!.takePicture();

      imagePath.add(picture);

      media.add(
        Media(
          mediaXFile: picture,
          mediaID: picture.hashCode,
          mediaURL: MediaURL(
            bigURL: Rx<String>(picture.path),
            normalURL: Rx<String>(picture.path),
            minURL: Rx<String>(picture.path),
          ),
        ),
      );

      camfilter.insert(
        0,
        FilterItem(
          media: Media(
            mediaXFile: picture,
            mediaID: picture.hashCode,
            mediaURL: MediaURL(
              bigURL: Rx<String>(picture.path),
              normalURL: Rx<String>(picture.path),
              minURL: Rx<String>(picture.path),
            ),
          ),
          isImage: true,
        ),
      );

      filterpage++;
      camfiltercontroller.value.jumpToPage(filterpage.value);
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }

    takePictureProcess.value = false;
  }

  void changeflash() {
    if (flashIcon.value == Icons.flash_auto_rounded) {
      flashIcon.value = Icons.flash_on_rounded;
      flashMode.value = FlashMode.always;
    } else if (flashIcon.value == Icons.flash_on_rounded) {
      flashIcon.value = Icons.flash_off_rounded;
      flashMode.value = FlashMode.off;
    } else if (flashIcon.value == Icons.flash_off_rounded) {
      flashIcon.value = Icons.flash_auto_rounded;
      flashMode.value = FlashMode.auto;
    }
  }

  void changeCamera() async {
    await cameraController.value!.dispose();

    if (camScreen.value == 1) {
      camScreen.value = 0;
    } else {
      camScreen.value = 1;
    }

    initializeControllerFuture.value = initializeCamera();

    initializeCamera();
  }

  Future<void> saveMedia() async {
    if (savemediaProcess.value) {
      return;
    }

    savemediaProcess.value = true;

    MediaAPI f = MediaAPI(currentUser: user.value!);
    MediaUploadResponse response = await f.upload(
        category: "-1",
        files: [camfilter[filterpage.value].media!.mediaXFile!]);
    if (!response.result.status) {
      log(response.result.description);
      savemediaProcess.value = false;
      camfilter[filterpage.value].loadingStatus = false;

      return;
    }

    camfilter[filterpage.value].loadingStatus = true;
    savemediaProcess.value = false;
  }
}
