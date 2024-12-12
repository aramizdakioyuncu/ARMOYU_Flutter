import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class StationAPI {
  final User currentUser;
  StationAPI({required this.currentUser});

  Future<StationFetchListResponse> fetchStations() async {
    return await API.service.stationServices.fetchStations();
  }

  Future<StationFetchListResponse> fetchfoodstation() async {
    return await API.service.stationServices.fetchfoodstation();
  }

  Future<StationFetchEquipmentListResponse> fetchEquipments(
      {required int stationID}) async {
    return await API.service.stationServices
        .fetchEquipments(stationID: stationID);
  }
}
