import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsSurvey {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> fetchSurveys(int page) async {
    Map<String, String> formData = {"sayfa": "$page"};
    Map<String, dynamic> jsonData =
        await apiService.request("anketler/liste/0/", formData);
    return jsonData;
  }
}
