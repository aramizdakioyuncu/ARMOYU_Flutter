import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool isLoggedIn = false;

    isLoggedIn = ARMOYU.appUsers.isEmpty;

    if (!isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    log("Page is being called");
    return super.onPageCalled(page);
  }

  @override
  void onPageDispose() {
    log("Page is being disposed");
    super.onPageDispose();
  }
}
