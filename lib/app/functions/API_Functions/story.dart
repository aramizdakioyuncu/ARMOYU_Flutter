import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsStory {
  final User currentUser;
  late final ApiService apiService;

  FunctionsStory({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> stories(int page) async {
    Map<String, String> formData = {"sayfa": "$page", "limit": "20"};
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

  Future<Map<String, dynamic>> view(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/bak/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> fetchviewlist(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/goruntuleyenler/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> like(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/begeni-ekle/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> likeremove(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/begeni-sil/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> likerslist(int storyID) async {
    Map<String, String> formData = {"hikayeID": "$storyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("hikaye/begenenler/0/", formData);
    return jsonData;
  }
}
