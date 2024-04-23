import 'package:ARMOYU/Services/API/api_service.dart';

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

  Future<Map<String, dynamic>> grouprequestanswer(
      int grupID, int answer) async {
    Map<String, String> formData = {"grupID": "$grupID", "cevap": "$answer"};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplar-davetcevap/0/0/", formData);
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
