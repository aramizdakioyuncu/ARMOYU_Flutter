import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/school_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
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
    SchoolFetchDetailResponse response =
        await f.fetchSchool(schoolID: schoolID);
    if (!response.result.status) {
      log(response.result.description.toString());
      schoolfetchProcess.value = false;
      setstatefunction();
      return;
    }
    schoolInfo.value = School(
      schoolID: response.response!.schoolID,
      schoolName: response.response!.schoolName,
      schoolshortName: response.response!.schoolShortName,
      schoolURL: response.response!.schoolURL,
      schoolBanner: Media(
        mediaID: response.response!.schoolBanner.mediaID,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.response!.schoolBanner.mediaURL.bigURL),
          normalURL:
              Rx<String>(response.response!.schoolBanner.mediaURL.normalURL),
          minURL: Rx<String>(response.response!.schoolBanner.mediaURL.minURL),
        ),
      ),
      schoolLogo: Media(
        mediaID: response.response!.schoolLogo.mediaID,
        mediaURL: MediaURL(
          bigURL: Rx<String>(response.response!.schoolLogo.mediaURL.bigURL),
          normalURL:
              Rx<String>(response.response!.schoolLogo.mediaURL.normalURL),
          minURL: Rx<String>(response.response!.schoolLogo.mediaURL.minURL),
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
