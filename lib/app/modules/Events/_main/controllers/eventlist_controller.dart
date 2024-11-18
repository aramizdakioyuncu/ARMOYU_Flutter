import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/event.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/event_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:get/get.dart';

class EventlistController extends GetxController {
  var eventsList = <Event>[].obs;
  var isfirstfetch = true.obs;
  var eventlistProecces = false.obs;
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

    if (isfirstfetch.value) {
      geteventslist();
    }
  }

  Future<void> geteventslist() async {
    if (eventlistProecces.value) {
      return;
    }

    eventlistProecces.value = true;

    EventAPI f = EventAPI(currentUser: currentUser.value!);
    Map<String, dynamic> response = await f.fetch();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      eventlistProecces.value = false;
      return;
    }

    eventsList.clear();
    for (dynamic element in response['icerik']) {
      List<User> aa = [];

      for (dynamic element2 in element['event_organizer']) {
        aa.add(
          User(
            userID: element2["player_ID"],
            displayName: Rx<String>(element2["player_displayname"]),
            avatar: Media(
              mediaID: element2["player_ID"],
              mediaURL: MediaURL(
                bigURL: Rx<String>(element2["player_avatar"]),
                normalURL: Rx<String>(element2["player_avatar"]),
                minURL: Rx<String>(element2["player_avatar"]),
              ),
            ),
          ),
        );
      }

      eventsList.add(
        Event(
          eventID: element["event_ID"],
          status: element["event_status"],
          name: element["event_name"],
          eventType: element["event_type"],
          eventDate: element["event_date"],
          gameImage: element["event_gamelogo"],
          image: element["event_foto"],
          detailImage: element["event_fotodetail"],
          banner: element["event_gamebanner"],
          eventorganizer: aa,
          eventPlace: element["event_location"],
          description: element["event_description"],
          rules: element["event_rules"],
          participantsLimit: element["event_participantlimit"],
          participantsCurrent: element["event_participantcurrent"],
          participantsgroupplayerlimit:
              element["event_participantgroupplayerlimit"],
          location: element["event_location"],
        ),
      );
    }

    eventlistProecces.value = false;
  }
}
