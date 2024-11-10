import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/dlc.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/event.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/file.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/role.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/event.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  final UserAccounts currentUserAccounts;

  EventController({
    required this.currentUserAccounts,
  });

  var event = Rx<Event?>(null);
  var didijoin = false.obs;

  var rulesacception = false.obs;

  var userParticipant = <User>[].obs;
  var groupParticipant = <Group>[].obs;

  var fetchParticipantProccess = false.obs;
  var fetcheventdetailProcess = false.obs;

  var dlcList = <DLCInfo>[].obs;
  var fileList = <FileInfo>[].obs;
  var detailList = [].obs;
  var eventdetailImage = Rx<String?>(null);
  var joineventProccess = false.obs;

  var date = "".obs;
  var time = "".obs;

  @override
  void onInit() {
    super.onInit();

    Map<String, dynamic> arguments = Get.arguments;

    event.value = arguments['event'];

    List<String> datetime = event.value!.eventDate!.split(' ');
    date.value = datetime[0];
    time.value = datetime[1];

    if (event.value!.participantgroupsList == null &&
        event.value!.participantpeopleList == null) {
      fetchparticipantList(event.value!.eventID);
    }

    fetcheventdetail(event.value!.eventID);
  }

  void onRefreshfunction() async {
    await fetchparticipantList(event.value!.eventID);
    fetcheventdetail(event.value!.eventID);
  }

  Future<void> fetcheventdetail(eventID) async {
    if (fetcheventdetailProcess.value) {
      return;
    }
    fetcheventdetailProcess.value = true;

    FunctionsEvent f = FunctionsEvent(
      currentUser: currentUserAccounts.user.value,
    );
    Map<String, dynamic> response = await f.detailfetch(eventID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      fetchParticipantProccess.value = false;
      return;
    }

    dlcList.clear();
    for (var dlc in response["icerik"]["dlc"]) {
      dlcList.add(
        DLCInfo(
          dlcID: dlc["dlc_ID"],
          dlcname: dlc["dlc_name"],
          dlcFile: dlc["dlc_file"],
        ),
      );
    }

    fileList.clear();
    for (var files in response["icerik"]["files"]) {
      fileList.add(
        FileInfo(
          fileID: files["file_ID"],
          fileType: files["file_type"],
          fileName: files["file_name"],
          fileURL: files["file_URL"],
        ),
      );
    }

    detailList.clear();
    for (var detail in response["icerik"]["detail"]) {
      detail["detail_ID"];
      if (detail["detail_name"] == "cekicilogo") {
        eventdetailImage = Rx<String>(detail["detail_info"]);
      }
      detailList.add(
        {
          "name": detail["detail_name"],
          "info": detail["detail_info"],
        },
      );
    }
  }

  Future<void> fetchparticipantList(eventID) async {
    if (fetchParticipantProccess.value) {
      return;
    }
    fetchParticipantProccess.value = true;
    FunctionsEvent f = FunctionsEvent(
      currentUser: currentUserAccounts.user.value,
    );
    Map<String, dynamic> response = await f.participantList(eventID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      fetchParticipantProccess.value = false;
      return;
    }

    userParticipant.clear();
    groupParticipant.clear();

    //Gruplu Katılımcılar
    int sayac = -1;
    for (var element in response["icerik"]["participant_groups"]) {
      sayac++;

      List<User> groupUsers = [];
      for (var element2 in response["icerik"]["participant_groups"][sayac]
          ["group_players"]) {
        groupUsers.add(
          User(
            userID: element2["player_ID"],
            displayName: element2["player_name"],
            userName: element2["player_username"],
            avatar: Media(
              mediaID: element2["player_ID"],
              mediaURL: MediaURL(
                bigURL: Rx<String>(element2["player_avatar"]),
                normalURL: Rx<String>(element2["player_avatar"]),
                minURL: Rx<String>(element2["player_avatar"]),
              ),
            ),
            role: Role(
                roleID: 0, name: element2["player_role"].toString(), color: ""),
          ),
        );
      }

      Group g = Group(
        groupID: element["group_ID"],
        groupLogo: Media(
          mediaID: element["group_ID"],
          mediaURL: MediaURL(
            bigURL: Rx<String>(element["group_logo"]),
            normalURL: Rx<String>(element["group_logo"]),
            minURL: Rx<String>(element["group_logo"]),
          ),
        ),
        groupBanner: Media(
          mediaID: element["group_ID"],
          mediaURL: MediaURL(
            bigURL: Rx<String>(element["group_banner"]),
            normalURL: Rx<String>(element["group_banner"]),
            minURL: Rx<String>(element["group_banner"]),
          ),
        ),
        groupName: element["group_name"],
        groupshortName: element["group_shortname"],
        groupUsers: groupUsers.obs,
      );
      groupParticipant.add(g);
    }

    //Bireysel Katılımcılar
    for (var element in response["icerik"]["participant_players"]) {
      if (element["player_ID"] == currentUserAccounts.user.value.userID) {
        didijoin.value = true;
      }

      userParticipant.add(
        User(
          userID: element["player_ID"],
          displayName: element["player_name"],
          userName: element["player_username"],
          avatar: Media(
            mediaID: element["player_ID"],
            mediaURL: MediaURL(
              bigURL: Rx<String>(element["player_avatar"]),
              normalURL: Rx<String>(element["player_avatar"]),
              minURL: Rx<String>(element["player_avatar"]),
            ),
          ),
        ),
      );
    }

    event.value!.participantpeopleList = userParticipant;
    event.value!.participantgroupsList = groupParticipant;

    fetchParticipantProccess.value = false;
  }

  Future<void> joinevent() async {
    if (!rulesacception.value) {
      String gelenyanit = "Kuralları kabul etmediniz!";
      ARMOYUWidget.stackbarNotification(Get.context!, gelenyanit);
      return;
    }

    joineventProccess.value = true;

    FunctionsEvent f =
        FunctionsEvent(currentUser: currentUserAccounts.user.value);
    Map<String, dynamic> response =
        await f.joinOrleave(event.value!.eventID, true);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    await fetchparticipantList(event.value!.eventID);
    joineventProccess.value = false;
  }

  Future<void> leaveevent() async {
    joineventProccess.value = true;

    FunctionsEvent f = FunctionsEvent(
      currentUser: currentUserAccounts.user.value,
    );
    Map<String, dynamic> response =
        await f.joinOrleave(event.value!.eventID, false);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    await fetchparticipantList(event.value!.eventID);

    didijoin.value = false;
    joineventProccess.value = false;
  }
}
