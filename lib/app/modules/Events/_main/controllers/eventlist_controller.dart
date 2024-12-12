import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/event.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/event_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/event/event.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/user.dart' as armoyuuser;
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
    EventResponse response = await f.fetch();
    if (!response.result.status) {
      log(response.result.description);
      eventlistProecces.value = false;
      return;
    }

    eventsList.clear();

    for (APIEvent element in response.response!) {
      List<User> organizerList = [];

      for (armoyuuser.UserInfo element in element.organizer) {
        organizerList.add(
          User(
            userID: element.userID,
            displayName: Rx<String>(element.displayname),
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

      eventsList.add(
        Event(
          eventID: element.eventID,
          status: int.parse(element.status),
          name: element.name,
          eventType: element.type,
          eventDate: element.date,
          gameImage: element.gameLogo,
          image: element.foto,
          detailImage: element.fotoDetail,
          banner: element.gameBanner,
          eventorganizer: organizerList,
          eventPlace: element.location,
          description: element.description,
          rules: element.rules,
          participantsLimit: element.participantLimit,
          participantsCurrent: element.participantCurrent,
          participantsgroupplayerlimit: element.participantGroupPlayerLimit,
          location: element.location,
        ),
      );
    }

    eventlistProecces.value = false;
  }
}
