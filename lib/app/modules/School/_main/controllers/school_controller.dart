import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/school_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:get/get.dart';

class SchoolController extends GetxController {
  var schoolfetchProcess = false.obs;
  var schoolInfo = Rx<School?>(null);

  late var currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUser.value =
        findCurrentAccountController.currentUserAccounts.value.user.value;

    Map<String, dynamic> arguments = Get.arguments;

    if (arguments["school"] == null) {
      int schoolID = arguments['schoolID'] as int;
      schoolinfofetch(schoolID);
    } else {
      schoolInfo.value = arguments["school"];
    }
  }

  Future<void> schoolinfofetch(int schoolID) async {
    if (schoolfetchProcess.value) {
      return;
    }
    schoolfetchProcess.value = true;
    setstatefunction();
    SchoolAPI f = SchoolAPI(currentUser: currentUser.value!);
    Map<String, dynamic> response = await f.fetchSchool(schoolID: schoolID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      schoolfetchProcess.value = false;
      setstatefunction();
      return;
    }
    schoolInfo.value = School(
      schoolID: response["icerik"]["school_ID"],
      schoolName: response["icerik"]["school_name"],
      schoolshortName: response["icerik"]["school_shortname"],
      schoolURL: response["icerik"]["school_URL"],
      schoolBanner: Media(
        mediaID: response["icerik"]["school_banner"]["media_ID"],
        mediaURL: MediaURL(
          bigURL:
              Rx<String>(response["icerik"]["school_banner"]["media_bigURL"]),
          normalURL:
              Rx<String>(response["icerik"]["school_banner"]["media_URL"]),
          minURL:
              Rx<String>(response["icerik"]["school_banner"]["media_minURL"]),
        ),
      ),
      schoolLogo: Media(
        mediaID: response["icerik"]["school_logo"]["media_ID"],
        mediaURL: MediaURL(
          bigURL: Rx<String>(response["icerik"]["school_logo"]["media_bigURL"]),
          normalURL: Rx<String>(response["icerik"]["school_logo"]["media_URL"]),
          minURL: Rx<String>(response["icerik"]["school_logo"]["media_minURL"]),
        ),
      ),
    );

    setstatefunction();
  }

  Future<void> handleRefresh() async {}

  setstatefunction() {
    // if (mounted) {
    //   setState(() {});
    // }
  }
}
