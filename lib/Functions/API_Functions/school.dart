import '../../Services/API/api_service.dart';

class FunctionsSchool {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> getschools() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("okullar/0/0/", formData);
    return jsonData;
  }
}
