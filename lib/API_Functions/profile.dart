import 'package:ARMOYU/Core/app_core.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<Map<String, dynamic>> friendremove(int userID) async {
    Map<String, String> formData = {"oyuncubakid": "$userID"};
    Map<String, dynamic> jsonData =
        await apiService.request("arkadas-cikar/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> changeavatar(List<XFile> files) async {
    List<MultipartFile> photosCollection = [];
    for (var file in files) {
      photosCollection.add(await AppCore.generateImageFile("resim", file));
    }

    Map<String, String> formData = {"text": "$files"};

    Map<String, dynamic> jsonData = await apiService
        .request("avatar-guncelle/0/0/", formData, files: photosCollection);
    return jsonData;
  }

  Future<Map<String, dynamic>> changebanner(List<XFile> files) async {
    List<MultipartFile> photosCollection = [];
    for (var file in files) {
      photosCollection.add(await AppCore.generateImageFile("resim", file));
    }

    Map<String, String> formData = {"text": "$files"};

    Map<String, dynamic> jsonData = await apiService
        .request("arkaplan-guncelle/0/0/", formData, files: photosCollection);
    return jsonData;
  }
}
