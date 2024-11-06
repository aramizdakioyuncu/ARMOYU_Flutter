import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/school.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/functions/API_Functions/school.dart';
import 'package:get/get.dart';

class SchoolController extends GetxController {
  final User currentUser;
  final int schoolID;
  final School? school;

  SchoolController({
    required this.currentUser,
    required this.schoolID,
    this.school,
  });
  var schoolfetchProcess = false.obs;
  var schoolInfo = Rx<School?>(null);

  @override
  void onInit() {
    super.onInit();

    if (school == null) {
      final Map<String, dynamic> arguments =
          Get.arguments as Map<String, dynamic>;

      int schoolID = arguments['schoolID'] as int;
      schoolinfofetch(schoolID);
    } else {
      schoolInfo.value = school!;
    }
  }

  Future<void> schoolinfofetch(int schoolID) async {
    if (schoolfetchProcess.value) {
      return;
    }
    schoolfetchProcess.value = true;
    setstatefunction();
    FunctionsSchool f = FunctionsSchool(currentUser: currentUser);
    Map<String, dynamic> response = await f.fetchSchool(schoolID);
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
          bigURL: response["icerik"]["school_logo"]["media_bigURL"],
          normalURL: response["icerik"]["school_logo"]["media_URL"],
          minURL: response["icerik"]["school_logo"]["media_minURL"],
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
