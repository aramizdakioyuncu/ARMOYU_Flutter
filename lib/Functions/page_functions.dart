import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:flutter/material.dart';

class PageFunctions {
  static pushProfilePage(
      BuildContext context, User currentUser, ScrollController scrollController,
      {bool ismyProfile = false}) {
    if (!ismyProfile &&
        (currentUser.userID == ARMOYU.appUsers[ARMOYU.selectedUser].userID ||
            currentUser.userName ==
                ARMOYU.appUsers[ARMOYU.selectedUser].userName)) {
      log("Kendi Profiline girmezsin!");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          currentUser: currentUser,
          ismyProfile: ismyProfile,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
