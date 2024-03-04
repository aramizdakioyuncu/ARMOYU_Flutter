import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsEvent {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> fetch() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("etkinlikler/liste/0/", formData);
    return jsonData;
  }
}
