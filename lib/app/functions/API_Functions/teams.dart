import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsTeams {
  final User currentUser;
  late final ApiService apiService;

  FunctionsTeams({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> fetch() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("takimlar/liste/", formData);
    return jsonData;
  }
}
