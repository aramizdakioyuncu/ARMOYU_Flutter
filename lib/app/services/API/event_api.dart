import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class EventAPI {
  final User currentUser;
  EventAPI({required this.currentUser});

  Future<EventResponse> fetch() async {
    return await API.service.eventServices.fetch();
  }

  Future<EventDetailResponse> detailfetch({required int eventID}) async {
    return await API.service.eventServices.detailfetch(eventID: eventID);
  }

  Future<EventJoinorLeaveResponse> joinOrleave(
      {required int eventID, required bool status}) async {
    return await API.service.eventServices.joinOrleave(
      eventID: eventID,
      status: status,
    );
  }

  Future<EventParticipantResponse> participantList(
      {required int eventID}) async {
    return await API.service.eventServices.participantList(eventID: eventID);
  }
}
