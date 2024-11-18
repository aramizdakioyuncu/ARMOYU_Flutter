import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class StationAPI {
  final User currentUser;
  StationAPI({required this.currentUser});

  Future<Map<String, dynamic>> fetchStations() async {
    return await API.service.stationServices.fetchStations(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> fetchfoodstation() async {
    return await API.service.stationServices.fetchfoodstation(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> fetchEquipments({
    required int stationID,
  }) async {
    return await API.service.stationServices.fetchEquipments(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      stationID: stationID,
    );
  }
}
