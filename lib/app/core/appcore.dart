// ignore_for_file: unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AppCore {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<List<XFile>> pickImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage();
    return images;
  }

  static Future<XFile?> pickImage({
    bool willbeCrop = false,
    CropAspectRatioPreset cropsquare = CropAspectRatioPreset.original,
  }) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }

    if (willbeCrop) {
      //Kırpma İşlemi
      XFile? selectedCroppedImage = await cropperImage(
        image,
        cropaspectRatio: cropsquare,
      );
      if (selectedCroppedImage == null) {
        return null;
      }
      image = selectedCroppedImage;
      //Kırpma İşlemi
    }

    image = await compressImage(image);
    return image;
  }

  static Future<XFile?> cropperImage(
    XFile image, {
    CropAspectRatioPreset cropaspectRatio = CropAspectRatioPreset.original,
  }) async {
    double? ratioX;
    double? ratioY;
    if (cropaspectRatio == CropAspectRatioPreset.ratio16x9) {
      ratioX = 16;
      ratioY = 9;
    } else if (cropaspectRatio == CropAspectRatioPreset.square) {
      ratioX = 1;
      ratioY = 1;
    }
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: (ratioX != null && ratioY != null)
          ? CropAspectRatio(ratioX: ratioX, ratioY: ratioY)
          : null,
    );

    if (croppedFile != null) {
      // CroppedFile'dan XFile oluştur
      return XFile(croppedFile.path);
    } else {
      return null;
    }
  }

  static Future<XFile> compressImage(XFile image) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    final originaldata = await image.readAsBytes();
    final originalnewkb = originaldata.length / 1024;
    final originalnewMb = originalnewkb / 1024;

    if (kDebugMode) {
      print('original images size : $originalnewMb');
    }

    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      minHeight: 500,
      minWidth: 500,
      quality: 90,
    );

    final data = await result!.readAsBytes();
    final newkb = data.length / 1024;
    final newMb = newkb / 1024;

    if (kDebugMode) {
      print('compress images size : $newMb');
    }

    return XFile(result.path);
  }

  // static Future<MultipartFile> generateImageFile(
  //     String text, XFile file) async {
  //   final fileBytes = await file.readAsBytes();
  //   return MultipartFile.fromBytes(text, fileBytes, filename: file.name);
  // }

  static Future<bool> checkInternetConnection() async {
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }
}
