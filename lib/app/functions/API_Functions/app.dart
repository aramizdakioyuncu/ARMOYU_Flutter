import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsApp {
  final User currentUser;
  late final ApiService apiService;

  FunctionsApp({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> sitemesaji() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("sitemesajidetay/0/0/", formData);
    return jsonData;
  }
}
