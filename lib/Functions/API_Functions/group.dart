import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Services/API/api_service.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class FunctionsGroup {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> groupFetch(int grupID) async {
    Map<String, String> formData = {"grupID": "$grupID"};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> groupusersFetch(int grupID) async {
    Map<String, String> formData = {"grupID": "$grupID"};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar/uyeler/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> groupleave(int grupID) async {
    Map<String, String> formData = {"grupID": "$grupID"};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar/ayril/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> groupsettingsSave({
    required int grupID,
    required String groupName,
    required String groupshortName,
    required String description,
    required String discordInvite,
    required String webLINK,
    required bool joinStatus,
  }) async {
    Map<String, String> formData = {
      "grupID": "$grupID",
      "baslik": groupName,
      "grupetiket": groupshortName,
      "aciklama": description,
      "discordlink": discordInvite,
      "website": webLINK,
      "alimdurum": joinStatus == true ? "1" : "0",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar/ayarlar/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> changegroupmedia(List<XFile> files,
      {required int groupID, required String category}) async {
    List<MultipartFile> photosCollection = [];
    for (var file in files) {
      photosCollection.add(await AppCore.generateImageFile("media", file));
    }

    Map<String, String> formData = {
      "groupID": "$groupID",
      "category": category,
    };

    Map<String, dynamic> jsonData = await apiService
        .request("gruplar/medya/0/", formData, files: photosCollection);
    return jsonData;
  }

  Future<Map<String, dynamic>> grouprequestanswer(
      int grupID, int answer) async {
    Map<String, String> formData = {"grupID": "$grupID", "cevap": "$answer"};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar-davetcevap/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> userInvite(
      {required int groupID, required List<User> userList}) async {
    Map<String, String> formData = {"grupID": "$groupID"};

    for (int i = 0; i < userList.length; i++) {
      formData['users[$i]'] = userList[i].userName!;
    }

    Map<String, dynamic> jsonData =
        await apiService.request("gruplar/davetet/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> userRemove(
      {required int groupID, required int userID}) async {
    Map<String, String> formData = {
      "grupID": "$groupID",
      "userID": "$userID",
    };

    Map<String, dynamic> jsonData =
        await apiService.request("gruplar/gruptanat/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> groupcreate(String grupadi, String kisaltmaadi,
      int grupkategori, int grupkategoridetay, int varsayilanoyun) async {
    Map<String, String> formData = {
      "grupadi": grupadi,
      "kisaltmaadi": kisaltmaadi,
      "grupkategori": "$grupkategori",
      "grupkategoridetay": "$grupkategoridetay",
      "varsayilanoyun": "$varsayilanoyun"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar-olustur/0/0/", formData);
    return jsonData;
  }
}
