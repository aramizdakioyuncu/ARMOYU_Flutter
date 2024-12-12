import 'dart:developer';

import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:get/get.dart';

class AccountUserController extends GetxController {
  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));
  @override
  void onInit() {
    super.onInit();

    log("-----------------------------Account Controller-----------------------------");

    if (ARMOYU.appUsers.isNotEmpty) {
      currentUserAccounts.value = ARMOYU.appUsers.first;
    }
  }

  // Kullanıcıyı değiştir
  void changeUser(UserAccounts userAccounts) {
    currentUserAccounts.value = userAccounts;
  }
}
