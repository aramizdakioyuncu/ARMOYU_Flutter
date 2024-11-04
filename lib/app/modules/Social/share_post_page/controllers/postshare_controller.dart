import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PostshareController extends GetxController {
  final User currentUser;
  PostshareController({
    required this.currentUser,
  });
  var postsharetext = TextEditingController().obs;
  var media = <Media>[].obs;
  var postshareProccess = false.obs;
  var key = GlobalKey<FlutterMentionsState>().obs;
  var userLocation = Rx<String?>(null);

  Future<void> sharePost() async {
    if (postshareProccess.value) {
      return;
    }

    postshareProccess.value = true;
    setstatefunction();
    FunctionsPosts funct = FunctionsPosts(currentUser: currentUser);
    Map<String, dynamic> response = await funct.share(
      key.value.currentState!.controller!.text,
      media,
      location: userLocation.value,
    );
    if (response["durum"] == 0) {
      postsharetext.value.text = response["aciklama"].toString();
      postshareProccess.value = false;
      setstatefunction();

      return;
    }

    if (response["durum"] == 1) {
      postsharetext.value.text = response["aciklama"].toString();
      postshareProccess.value = false;
      setstatefunction();

      Get.back();
    }
  }

  void setstatefunction() {}

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
