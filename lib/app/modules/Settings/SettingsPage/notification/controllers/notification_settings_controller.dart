import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/core/widgets.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
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
  // var currentUserAccounts =
  //     Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    // currentUserAccounts = findCurrentAccountController.currentUserAccounts;
    if (notifiCalling == null) {
      fetchNotificationdetail();
    }
  }

  Future<void> fetchNotificationdetail() async {
    if (firstfetchnotifi.value) {
      return;
    }

    firstfetchnotifi.value = true;

    NotificationSettingsResponse response =
        await API.service.notificationServices.listNotificationSettings();

    if (!response.result.status) {
      log(response.result.description);
      ARMOYUWidget.toastNotification(response.result.description);

      firstfetchnotifi.value = false;
      return;
    }

    notifiPostLike =
        response.response!.paylasimBegeni == 1 ? true.obs : false.obs;
    notifiCommentLike =
        response.response!.yorumBegeni == 1 ? true.obs : false.obs;

    notifiComments =
        response.response!.paylasimYorum == 1 ? true.obs : false.obs;
    notifiReplyComment =
        response.response!.yorumYanit == 1 ? true.obs : false.obs;

    notifiEvents = response.response!.etkinlik == 1 ? true.obs : false.obs;
    notifiBirthdays = response.response!.dogumGunu == 1 ? true.obs : false.obs;
    notifiMessages = response.response!.mesajlar == 1 ? true.obs : false.obs;
    notifiCalling = response.response!.aramalar == 1 ? true.obs : false.obs;
    notifiMention = response.response!.bahsetmeler == 1 ? true.obs : false.obs;

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

    NotificationSettingsUpdateResponse response = await API
        .service.notificationServices
        .updateNotificationSettings(options: settingsNotification);

    if (!response.result.status) {
      log(response.result.description);
      ARMOYUWidget.toastNotification(response.result.description);
      updatesettingProcess.value = false;
      return;
    }
    ARMOYUWidget.toastNotification(response.result.description);

    updatesettingProcess.value = false;
  }
}
