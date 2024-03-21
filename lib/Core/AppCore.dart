import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class AppCore {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<List<XFile>> pickImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage();
    return images;
  }

  static Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<MultipartFile> generateImageFile(
      String text, XFile file) async {
    final fileBytes = await file.readAsBytes();
    return MultipartFile.fromBytes(text, fileBytes, filename: file.name);
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
