import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsApp {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> sitemesaji() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("sitemesajidetay/0/0/", formData);
    return jsonData;
  }
}
