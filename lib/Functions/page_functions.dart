import 'dart:developer';

import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:flutter/material.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          currentUser: currentUser,
          profileUser: userProfile,
          ismyProfile: ismyProfile,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
