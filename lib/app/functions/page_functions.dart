import 'dart:developer';

import 'package:ARMOYU/app/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageFunctions {
  final User currentUser;
  PageFunctions({
    required this.currentUser,
  });

  void pushProfilePage(
      BuildContext context, User userProfile, ScrollController scrollController,
      {bool ismyProfile = false}) {
    if (!ismyProfile &&
        (userProfile.userID == currentUser.userID ||
            userProfile.userName == currentUser.userName)) {
      log("Kendi Profiline girmezsin!");
      return;
    }

    Get.toNamed(
      "/profile/${userProfile.userID ?? userProfile.userName}",
      arguments: {"profileUser": userProfile, "currentUser": currentUser},
    );
  }
}
