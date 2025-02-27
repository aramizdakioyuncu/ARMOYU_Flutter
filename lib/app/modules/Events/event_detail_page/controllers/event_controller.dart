import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/dlc.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/event.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/file.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/group.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/role.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
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

    EventDetailResponse response =
        await API.service.eventServices.fetchdetail(eventID: eventID);
    if (!response.result.status) {
      log(response.result.description);
      fetchParticipantProccess.value = false;
      return;
    }

    dlcList.clear();
    for (var element in response.response!.dlc) {
      dlcList.add(
        DLCInfo(
          dlcID: element["dlc_ID"],
          dlcname: element["dlc_name"],
          dlcFile: element["dlc_file"],
        ),
      );
    }

    fileList.clear();
    for (var element in response.response!.files) {
      fileList.add(
        FileInfo(
          fileID: element["file_ID"],
          fileType: element["file_type"],
          fileName: element["file_name"],
          fileURL: element["file_URL"],
        ),
      );
    }

    detailList.clear();
    for (var element in response.response!.detail) {
      if (element["detail_name"] == "cekicilogo") {
        eventdetailImage = Rx<String>(element["detail_info"]);
      }
      detailList.add(
        {
          "name": element["detail_name"],
          "info": element["detail_info"],
        },
      );
    }
  }

  Future<void> fetchparticipantList(eventID) async {
    if (fetchParticipantProccess.value) {
      return;
    }
    fetchParticipantProccess.value = true;

    EventParticipantResponse response =
        await API.service.eventServices.participantList(eventID: eventID);
    if (!response.result.status) {
      log(response.result.description);
      fetchParticipantProccess.value = false;
      return;
    }

    userParticipant.clear();
    groupParticipant.clear();

    //Gruplu Katılımcılar
    int sayac = -1;

    for (var element in response.response!.groups) {
      sayac++;

      List<User> groupUsers = [];

      for (var element2 in response.response!.groups[sayac].groupPlayers) {
        groupUsers.add(
          User(
            userID: element2.userID,
            displayName: Rx<String>(element2.displayname),
            userName: Rx<String>(element2.username!),
            avatar: Media(
              mediaID: element2.userID,
              mediaURL: MediaURL(
                bigURL: Rx<String>(element2.avatar.bigURL),
                normalURL: Rx<String>(element2.avatar.normalURL),
                minURL: Rx<String>(element2.avatar.minURL),
              ),
            ),
            role: Role(
              roleID: 0,
              name: element2.role.toString(),
              color: "",
            ),
          ),
        );
      }

      Group g = Group(
        groupID: element.groupID,
        groupLogo: Media(
          mediaID: element.groupID,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element.groupLogo),
            normalURL: Rx<String>(element.groupLogo),
            minURL: Rx<String>(element.groupLogo),
          ),
        ),
        groupBanner: Media(
          mediaID: element.groupID,
          mediaURL: MediaURL(
            bigURL: Rx<String>(element.groupBanner),
            normalURL: Rx<String>(element.groupBanner),
            minURL: Rx<String>(element.groupBanner),
          ),
        ),
        groupName: element.groupName,
        groupshortName: element.groupShortname,
        groupUsers: groupUsers.obs,
      );
      groupParticipant.add(g);
    }

    //Bireysel Katılımcılar

    for (var element in response.response!.players) {
      if (element.userID == currentUser.value!.userID) {
        didijoin.value = true;
      }

      userParticipant.add(
        User(
          userID: element.userID,
          displayName: Rx<String>(element.displayname),
          userName: Rx<String>(element.username!),
          avatar: Media(
            mediaID: element.userID,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.avatar.bigURL),
              normalURL: Rx<String>(element.avatar.normalURL),
              minURL: Rx<String>(element.avatar.minURL),
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

    EventJoinorLeaveResponse response = await API.service.eventServices
        .joinOrleave(eventID: event.value!.eventID, status: true);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    await fetchparticipantList(event.value!.eventID);
    joineventProccess.value = false;
  }

  Future<void> leaveevent() async {
    joineventProccess.value = true;

    EventJoinorLeaveResponse response = await API.service.eventServices
        .joinOrleave(eventID: event.value!.eventID, status: false);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    await fetchparticipantList(event.value!.eventID);

    didijoin.value = false;
    joineventProccess.value = false;
  }
}
