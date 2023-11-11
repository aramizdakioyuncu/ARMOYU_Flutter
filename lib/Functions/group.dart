import '../Services/api_service.dart';

class FunctionsGroup {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> grouprequestanswer(
      int grupID, int answer) async {
    Map<String, String> formData = {"grupID": "$grupID", "cevap": "$answer"};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar-davetcevap/0/0/", formData);
    return jsonData;
  }
}
