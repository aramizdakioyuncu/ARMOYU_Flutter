import 'dart:developer';

import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageFunctions {
  final UserAccounts currentUserAccounts;
  PageFunctions({
    required this.currentUserAccounts,
  });

  void pushProfilePage(
      BuildContext context, User userProfile, ScrollController scrollController,
      {bool ismyProfile = false}) {
    if (!ismyProfile &&
        (userProfile.userID == currentUserAccounts.user.userID ||
            userProfile.userName == currentUserAccounts.user.userName)) {
      log("Kendi Profiline girmezsin!");
      return;
    }

    Get.toNamed(
      "/profile/${userProfile.userID ?? userProfile.userName}",
      arguments: {
        "profileUser": userProfile,
        "currentUser": currentUserAccounts
      },
    );
  }
}
