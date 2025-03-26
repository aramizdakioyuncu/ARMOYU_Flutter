import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu/app/core/appcore.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu/app/modules/utils/noconnectionpage/views/noconnection_view.dart';
import 'package:armoyu/app/services/utility/onesignal.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/core/armoyu.dart';
import 'package:armoyu_widgets/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartingpageController extends GetxController {
  var connectionstatus = ''.obs;
  var connectionProcess = false.obs;

  // // Aktif Kullanıcı Controller
  // final accountController = Get.put(AccountUserController(), permanent: true);
  // // Aktif Kullanıcı Controller

  @override
  void onInit() {
    super.onInit();
    log("Anasayfaya Hoşgeldiniz");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startingfunctions();
    });
  }

  @override
  void onClose() {
    super.onClose();
    log("Anasayfadan Çıktınız");
  }

  Future<bool> checkInternetConnectionv2() async {
    // İnternet var mı diye kontrol ediyoruz!
    if (!await AppCore.checkInternetConnection()) {
      Get.to(() => const NoConnectionpageView());

      return false;
    }
    return true;
  }

  Future<void> startingfunctions() async {
    String? sesssionTOKEN;

    if (ARMOYU.appUsers.isEmpty) {
      //Oturum Kaydı olmadığı için Giriş ekranına yönlendiriliyor

      Get.offAndToNamed("/login");
      return;
    }

    sesssionTOKEN = ARMOYU.appUsers.first.sessionTOKEN.value;
    log("TOKENN :$sesssionTOKEN");
    log("Açık Kullanıcı Hesabı : ${ARMOYU.appUsers.length}");

    int sirasay = 0;
    for (UserAccounts userInfo in ARMOYU.appUsers) {
      sirasay++;

      log("$sirasay. Ad: ${userInfo.user.value.displayName} TOKEN : ${userInfo.sessionTOKEN.value}");
      if (userInfo.user.value.myFriends == null) {
        continue;
      }
      log("->Arkadaş sayısı: ${userInfo.user.value.myFriends!.length.toString()}");
      int sirasay2 = 0;

      for (User friendslist in userInfo.user.value.myFriends!) {
        sirasay2++;

        log("-->$sirasay2. Ad: ${friendslist.displayName} Son Giriş: ${"" /*friendslist.lastloginv2*/}");
      }
    }

    API.service.authServices.setbarriertoken(barriertoken: sesssionTOKEN);

    bool statusinternet = await checkInternetConnectionv2();
    if (!statusinternet) {
      //Oturum Kaydı var internet yok app ekranına yönlendiriliyor
      // accountController.changeUser(ARMOYU.appUsers.first);
      //APIACCOUNTSERVICES
      API.widgets.accountController.changeUser(ARMOYU.appUsers.first);
      //APIACCOUNTSERVICES
      OneSignalApi.setupOneSignal(currentUserAccounts: ARMOYU.appUsers.first);
      Get.offAndToNamed("/app");
      return;
    }
    appstatuscheck(sesssionTOKEN);

    // accountController.changeUser(ARMOYU.appUsers.first);
    //APIACCOUNTSERVICES
    API.widgets.accountController.changeUser(ARMOYU.appUsers.first);
    //APIACCOUNTSERVICES
    OneSignalApi.setupOneSignal(currentUserAccounts: ARMOYU.appUsers.first);
    Get.offAndToNamed("/app");
    return;
  }

  appstatuscheck(String sesssionTOKEN) async {
    LoginResponse response =
        await API.service.authServices.loginwithbarriertoken(
      barriertoken: sesssionTOKEN,
    );

    if (response.result.status) {
      log("Web Versiyon ${response.result.descriptiondetail["build"]}  > Sistem versiyon  ${int.parse(ARMOYU.appBuild)}");
      if (response.result.descriptiondetail["build"] >
          int.parse(ARMOYU.appBuild)) {
        ARMOYUFunctions.updateForce(Get.context);
        return;
      }

      if (response.result.description == "Oyuncu bilgileri yanlış!") {
        Get.offAndToNamed("/login");
        return;
      }
    }
  }
}
