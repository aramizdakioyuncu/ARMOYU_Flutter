import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsCountry {
  final User currentUser;
  late final ApiService apiService;

  FunctionsCountry({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> fetch() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("ulkeler/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> fetchprovince(int countryID) async {
    Map<String, String> formData = {"countryID": "$countryID"};
    Map<String, dynamic> jsonData =
        await apiService.request("iller/0/", formData);
    return jsonData;
  }
}
