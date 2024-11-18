import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class EventAPI {
  final User currentUser;
  EventAPI({required this.currentUser});

  Future<Map<String, dynamic>> fetch() async {
    return await API.service.eventServices.fetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> detailfetch({
    required int eventID,
  }) async {
    return await API.service.eventServices.detailfetch(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      eventID: eventID,
    );
  }

  Future<Map<String, dynamic>> joinOrleave({
    required int eventID,
    required bool status,
  }) async {
    return await API.service.eventServices.joinOrleave(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      eventID: eventID,
      status: status,
    );
  }

  Future<Map<String, dynamic>> participantList({
    required int eventID,
  }) async {
    return await API.service.eventServices.participantList(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      eventID: eventID,
    );
  }
}
