import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsNews {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> fetch(int page) async {
    Map<String, String> formData = {"sayfa": "$page", "limit": "10"};
    Map<String, dynamic> jsonData =
        await apiService.request("haberler/liste/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> fetchnews(int newsID) async {
    Map<String, String> formData = {"haberID": "$newsID"};
    Map<String, dynamic> jsonData =
        await apiService.request("haberler/detay/0/", formData);
    return jsonData;
  }
}
