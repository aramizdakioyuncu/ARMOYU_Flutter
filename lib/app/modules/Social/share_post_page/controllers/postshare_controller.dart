import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PostshareController extends GetxController {
  var postsharetext = TextEditingController().obs;
  var media = <Media>[].obs;
  var postshareProccess = false.obs;
  var key = GlobalKey<FlutterMentionsState>().obs;
  var userLocation = Rx<String?>(null);

  var currentUserAccounts =
      Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    //* *//
  }

  Future<void> sharePost() async {
    if (postshareProccess.value) {
      return;
    }

    postshareProccess.value = true;

    PostShareResponse response = await API.service.postsServices.share(
      text: key.value.currentState!.controller!.text,
      files: media.map((media) => media.mediaXFile!).toList(),
      location: userLocation.value,
    );
    if (!response.result.status) {
      postsharetext.value.text = response.result.description.toString();
      postshareProccess.value = false;

      return;
    }

    if (response.result.status) {
      postsharetext.value.text = response.result.description.toString();
      postshareProccess.value = false;

      Get.back();
    }
  }

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
