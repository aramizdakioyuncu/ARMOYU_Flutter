import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsTeams {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> fetch() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("takimlar/liste/", formData);
    return jsonData;
  }
}
