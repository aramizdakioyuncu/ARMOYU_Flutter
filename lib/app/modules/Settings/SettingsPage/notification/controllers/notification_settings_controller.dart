import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/notification.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:get/get.dart';

class NotificationsettingsController extends GetxController {
  Rx<bool>? notifiPostLike;
  Rx<bool>? notifiCommentLike;

  Rx<bool>? notifiComments;
  Rx<bool>? notifiReplyComment;

  Rx<bool>? notifiEvents;
  Rx<bool>? notifiBirthdays;
  Rx<bool>? notifiMessages;
  Rx<bool>? notifiCalling;
  Rx<bool>? notifiMention;

  var updatesettingProcess = false.obs;

  var firstfetchnotifi = false.obs;

  var settingsNotification = <String>[].obs;
  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts = findCurrentAccountController.currentUserAccounts;
    if (notifiCalling == null) {
      fetchNotificationdetail();
    }
  }

  Future<void> fetchNotificationdetail() async {
    if (firstfetchnotifi.value) {
      return;
    }

    firstfetchnotifi.value = true;

    FunctionsNotification f = FunctionsNotification(
        currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response = await f.listNotificationSettings();

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);

      firstfetchnotifi.value = false;
      return;
    }

    notifiPostLike =
        response["icerik"]["paylasimbegeni"] == 1 ? true.obs : false.obs;
    notifiCommentLike =
        response["icerik"]["yorumbegeni"] == 1 ? true.obs : false.obs;

    notifiComments =
        response["icerik"]["paylasimyorum"] == 1 ? true.obs : false.obs;
    notifiReplyComment =
        response["icerik"]["yorumyanit"] == 1 ? true.obs : false.obs;

    notifiEvents = response["icerik"]["etkinlik"] == 1 ? true.obs : false.obs;
    notifiBirthdays =
        response["icerik"]["dogumgunu"] == 1 ? true.obs : false.obs;
    notifiMessages = response["icerik"]["mesajlar"] == 1 ? true.obs : false.obs;
    notifiCalling = response["icerik"]["aramalar"] == 1 ? true.obs : false.obs;
    notifiMention =
        response["icerik"]["bahsetmeler"] == 1 ? true.obs : false.obs;

    firstfetchnotifi.value = false;
  }

  Future<void> savenotifi() async {
    if (updatesettingProcess.value) {
      return;
    }
    updatesettingProcess.value = true;

    settingsNotification.value = [];
    settingsNotification
        .add("paylasimbegeni= ${notifiPostLike!.value ? 1 : 0}");
    settingsNotification.add("paylasimyorum=${notifiComments!.value ? 1 : 0}");
    settingsNotification.add("yorumbegeni=${notifiCommentLike!.value ? 1 : 0}");
    settingsNotification.add("dogumgunu=${notifiBirthdays!.value ? 1 : 0}");
    settingsNotification.add("etkinlik=${notifiEvents!.value ? 1 : 0}");
    settingsNotification.add("yorumyanit=${notifiReplyComment!.value ? 1 : 0}");
    settingsNotification.add("mesajlar=${notifiMessages!.value ? 1 : 0}");
    settingsNotification.add("aramalar=${notifiCalling!.value ? 1 : 0}");
    settingsNotification.add("bahsetmeler=${notifiMention!.value ? 1 : 0}");

    FunctionsNotification f = FunctionsNotification(
        currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response =
        await f.updateNotificationSettings(settingsNotification);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      ARMOYUWidget.toastNotification(response["aciklama"]);
      updatesettingProcess.value = false;
      return;
    }
    ARMOYUWidget.toastNotification(response["aciklama"]);

    updatesettingProcess.value = false;
  }
}
