import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsJoinUs {
  final User currentUser;
  late final ApiService apiService;

  FunctionsJoinUs({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> fetchdepartment() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("yetkiler/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> applicationList(int page) async {
    Map<String, String> formData = {"sayfa": "$page"};
    Map<String, dynamic> jsonData =
        await apiService.request("ekibimiz/basvurular/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> requestjoindepartment(
    int positionID,
    String whyjoin,
    String whyposition,
    String howmachtime,
  ) async {
    Map<String, String> formData = {
      "positionID": "$positionID",
      "whyjoin": whyjoin,
      "whyposition": whyposition,
      "howmachtime": howmachtime,
    };
    Map<String, dynamic> jsonData =
        await apiService.request("ekibimiz/katil-istek/0/", formData);
    return jsonData;
  }
}
