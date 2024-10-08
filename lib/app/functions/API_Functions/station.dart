import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsStation {
  final User currentUser;
  late final ApiService apiService;

  FunctionsStation({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> fetchStations() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("istasyonlar/liste/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> fetchfoodstation() async {
    Map<String, String> formData = {"kategori": "yemek"};
    Map<String, dynamic> jsonData =
        await apiService.request("istasyonlar/liste/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> fetchEquipments(int stationID) async {
    Map<String, String> formData = {"istasyonID": "$stationID"};
    Map<String, dynamic> jsonData =
        await apiService.request("istasyonlar/ekipmanlar/0/", formData);
    return jsonData;
  }
}
