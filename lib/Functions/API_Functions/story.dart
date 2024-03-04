import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsStory {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> stories() async {
    Map<String, String> formData = {"sayfa": "1"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> addstory(
      String $imageURL, bool isEveryonePublish) async {
    Map<String, String> formData = {
      "hikayemedya": $imageURL,
      "hikayepaylasimkategori": "$isEveryonePublish"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/ekle/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> removestory(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/sil/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> hidestory(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/gizle/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> fetchviewlist(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/goruntuleyen/0/", formData);
    return jsonData;
  }
}
