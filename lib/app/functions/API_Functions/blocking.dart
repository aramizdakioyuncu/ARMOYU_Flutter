import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsBlocking {
  final User currentUser;
  late final ApiService apiService;

  FunctionsBlocking({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> list() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("engel/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> add(int userID) async {
    Map<String, String> formData = {"userID": "$userID"};
    Map<String, dynamic> jsonData =
        await apiService.request("engel/ekle/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> remove(int userID) async {
    Map<String, String> formData = {"userID": "$userID"};
    Map<String, dynamic> jsonData =
        await apiService.request("engel/sil/0/", formData);
    return jsonData;
  }
}
