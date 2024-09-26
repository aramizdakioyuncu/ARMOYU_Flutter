import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsNotification {
  final User currentUser;
  late final ApiService apiService;

  FunctionsNotification({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> listNotificationSettings() async {
    Map<String, String> formData = {};

    Map<String, dynamic> jsonData =
        await apiService.request("bildirimler/ayarlar/liste/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> updateNotificationSettings(
      List<String> options) async {
    Map<String, String> formData = {};

    for (int i = 0; i < options.length; i++) {
      formData['notification[$i]'] = options[i];
    }

    Map<String, dynamic> jsonData =
        await apiService.request("bildirimler/ayarlar/0/", formData);
    return jsonData;
  }
}
