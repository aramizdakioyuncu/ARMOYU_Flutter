import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsSearchEngine {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> hashtag(String hashtag, int page) async {
    Map<String, String> formData = {
      "etiket": hashtag,
      "sayfa": "$page",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("etiketler/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> searchengine(String searchword, int page) async {
    Map<String, String> formData = {"sayfa": "$page", "oyuncuadi": searchword};
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlyusers(String searchword, int page) async {
    Map<String, String> formData = {
      "sayfa": "$page",
      "oyuncuadi": searchword,
      "kategori": "oyuncular",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlygroups(String searchword, int page) async {
    Map<String, String> formData = {
      "sayfa": "$page",
      "oyuncuadi": searchword,
      "kategori": "gruplar",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlyschools(String searchword, int page) async {
    Map<String, String> formData = {"sayfa": "$page", "oyuncuadi": searchword};
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> onlyworks(String searchword, int page) async {
    Map<String, String> formData = {"sayfa": "$page", "oyuncuadi": searchword};
    Map<String, dynamic> jsonData =
        await apiService.request("arama/0/0/", formData);
    return jsonData;
  }
}
