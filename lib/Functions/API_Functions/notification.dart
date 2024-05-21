import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsNotification {
  final ApiService apiService = ApiService();

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
