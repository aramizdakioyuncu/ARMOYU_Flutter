import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsSearchEngine {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> searchengine(int page, String searchword) async {
    Map<String, String> formData = {"sayfa": "$page", "oyuncuadi": searchword};
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlyusers(int page, String searchword) async {
    Map<String, String> formData = {
      "sayfa": "$page",
      "oyuncuadi": searchword,
      "kategori": "oyuncular",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlygroups(int page, String searchword) async {
    Map<String, String> formData = {
      "sayfa": "$page",
      "oyuncuadi": searchword,
      "kategori": "gruplar",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlyschools(int page, String searchword) async {
    Map<String, String> formData = {"sayfa": "$page", "oyuncuadi": searchword};
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlyworks(int page, String searchword) async {
    Map<String, String> formData = {"sayfa": "$page", "oyuncuadi": searchword};
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }
}
