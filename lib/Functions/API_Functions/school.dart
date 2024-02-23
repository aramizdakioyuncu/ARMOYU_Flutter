import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsSchool {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> getschools() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("okullar/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> joinschool(String schoolID, String classID,
      String jobID, String classPassword) async {
    Map<String, String> formData = {
      "isyeriidi": schoolID,
      "hangisinif": classID,
      "hangibrans": jobID,
      "sinifsifresi": classPassword,
    };
    Map<String, dynamic> jsonData =
        await apiService.request("isyerleri/katil/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getschoolclass(String schoolID) async {
    Map<String, String> formData = {"hangisyeri": schoolID};
    Map<String, dynamic> jsonData =
        await apiService.request("isyerleri/icerik/0/", formData);
    return jsonData;
  }
}
