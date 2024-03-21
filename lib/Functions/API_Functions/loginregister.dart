import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsLoginRegister {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> inviteCodeTest(String code) async {
    Map<String, String> formData = {"davetkodu": code};
    Map<String, dynamic> jsonData =
        await apiService.request("davetkodsorgula/0/0/", formData);
    return jsonData;
  }
}
