import 'package:ARMOYU/Core/AppCore.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsProfile {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> invitelist(
    int page,
  ) async {
    Map<String, String> formData = {"sayfa": "$page", "limit": "30"};
    Map<String, dynamic> jsonData =
        await apiService.request("davetliste/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> invitecoderefresh() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("davetkodyenile/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> friendlist(int userID, int page) async {
    Map<String, String> formData = {
      "oyuncubakid": "$userID",
      "sayfa": "$page",
      "limit": "30"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("arkadaslarim/0/", formData);
    return jsonData;
  }

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

  Future<Map<String, dynamic>> selectfavteam(int? teamID) async {
    Map<String, String> formData = {"favoritakimID": "$teamID"};
    Map<String, dynamic> jsonData =
        await apiService.request("profil/favoritakimsec/0/", formData);
    return jsonData;
  }
}
