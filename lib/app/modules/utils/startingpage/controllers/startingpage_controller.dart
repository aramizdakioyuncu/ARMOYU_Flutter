import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/core/appcore.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/modules/utils/noconnectionpage/views/noconnection_view.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/services/socketio_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartingpageController extends GetxController {
  var connectionstatus = ''.obs;
  var connectionProcess = false.obs;

  @override
  void onInit() {
    super.onInit();

    log("Anasayfaya Hoşgeldiniz");

    staringfunctions();
  }

  @override
  void onClose() {
    super.onClose();
    log("Anasayfadan Çıktınız");
  }

  getFlutterInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    ARMOYU.appName = packageInfo.appName;
    ARMOYU.appPackage = packageInfo.packageName;

    ARMOYU.appVersion = packageInfo.version;
    ARMOYU.appBuild = packageInfo.buildNumber;
  }

  Future<String> getdeviceModel() async {
    //Cihaz Kontrolü yaoıyoruz
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print(androidInfo.model);
      return androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print(iosInfo.utsname.machine);
      return iosInfo.utsname.machine;
    }
    return "Bilinmeyen Cihaz";
  }

  getPlatform() {
    if (Platform.isAndroid) {
      ARMOYU.devicePlatform = "Android";
    } else if (Platform.isIOS) {
      ARMOYU.devicePlatform = "IOS";
    } else {
      ARMOYU.devicePlatform = "Bilinmeyen";
    }
  }

  Future<bool> checkInternetConnectionv2() async {
    // İnternet var mı diye kontrol ediyoruz!
    if (!await AppCore.checkInternetConnection()) {
      Get.to(() => const NoConnectionpageView());

      return false;
    }
    return true;
  }

  Future<void> staringfunctions() async {
    // Aktif Kullanıcı Controller
    final accountController = Get.put(AccountUserController(), permanent: true);
    // Aktif Kullanıcı Controller

    //Socket Bağlantısı
    Get.put(SocketioController(), permanent: true);
    //Socket Bağlantısı

    //Platform kontrolü yapıyoruz
    getPlatform();

    //Kameralar var mı diye kontrol
    ARMOYU.cameras = await availableCameras();

    //Cihaz Model yapıyoruz
    ARMOYU.deviceModel = await getdeviceModel();

    //Flutter Proje bilgisini çekiyoruz
    await getFlutterInfo();

    log("Cihaz Modeli: ${ARMOYU.deviceModel}");
    log("Platform: ${ARMOYU.devicePlatform}");

    log("Kameralar: ${ARMOYU.cameras!.length}");

    log("Proje Adı: ${ARMOYU.appName}");
    log("Proje Versiyon: ${ARMOYU.appVersion}");
    log("Proje Build: ${ARMOYU.appBuild}");

    //Bellekteki kullanıcı adı ve şifreyi alıyoruz
    final prefs = await SharedPreferences.getInstance();

    // Kullanıcı listesini SharedPreferences'den yükleme
    List<String>? usersJson = prefs.getStringList('users');

    String? sesssionTOKEN;

    //Listeye Yükle
    try {
      ARMOYU.appUsers.value = usersJson!
          .map((userJson) => UserAccounts.fromJson(jsonDecode(userJson)))
          .toList();
    } catch (e) {
      log(e.toString());
    }

    if (ARMOYU.appUsers.isNotEmpty) {
      sesssionTOKEN = ARMOYU.appUsers.first.sessionTOKEN.value;

      log("Açık Kullanıcı Hesabı : ${usersJson!.length}");

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

          log("-->$sirasay2. Ad: ${friendslist.displayName} Son Giriş: ${friendslist.lastloginv2}");
        }
      }
    }

    //Kullanıcı adı veya şifre kısmı null ise daha ileri kodlara gitmesini önler
    if (sesssionTOKEN == null) {
      Get.offNamed("/login");
      return;
    }

    if (usersJson == null) {
      bool statusinternet = await checkInternetConnectionv2();
      if (!statusinternet) {
        return;
      }
    }

    LoginResponse response = await API.service.authServices
        .loginwithbarriertoken(barriertoken: sesssionTOKEN);

    if (response.result.status) {
      log("Web Versiyon ${response.result.descriptiondetail["build"]}  > Sistem versiyon  ${int.parse(ARMOYU.appBuild)}");
      if (response.result.descriptiondetail["build"] >
          int.parse(ARMOYU.appBuild)) {
        ARMOYUFunctions.updateForce(Get.context);
        return;
      }

      if (response.result.description == "Oyuncu bilgileri yanlış!") {
        Get.offNamed("/login");
        return;
      }

      accountController.changeUser(ARMOYU.appUsers.first);

      Get.offNamed("/app");

      return;
    } else if (!response.result.status) {
      if (usersJson == null) {
        bool statusinternet = await checkInternetConnectionv2();
        if (!statusinternet) {
          return;
        }
      }

      //internet yok ama önceden giriş yapılmış verileri var
      accountController.changeUser(ARMOYU.appUsers.first);

      Get.toNamed("/app");

      return;
    }

    Get.offNamed("/login");
    return;
  }
}
