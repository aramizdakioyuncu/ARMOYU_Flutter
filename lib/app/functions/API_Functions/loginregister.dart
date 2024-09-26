import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsLoginRegister {
  final User currentUser;
  late final ApiService apiService;

  FunctionsLoginRegister({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> inviteCodeTest(String code) async {
    Map<String, String> formData = {"davetkodu": code};
    Map<String, dynamic> jsonData =
        await apiService.request("davetkodsorgula/0/0/", formData);
    return jsonData;
  }
}
