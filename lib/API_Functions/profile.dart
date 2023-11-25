import '../Services/api_service.dart';

class FunctionsProfile {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> friendrequest(int userID) async {
    Map<String, String> formData = {"oyuncubakid": "$userID"};
    Map<String, dynamic> jsonData =
        await apiService.request("arkadas-ol/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> friendrequestanswer(
      int userID, int answer) async {
    Map<String, String> formData = {
      "oyuncubakid": "$userID",
      "cevap": "$answer"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("arkadas-cevap/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> userdurting(int userID) async {
    Map<String, String> formData = {"oyuncubakid": "$userID"};
    Map<String, dynamic> jsonData =
        await apiService.request("arkadas-durt/0/0/", formData);
    return jsonData;
  }
}
