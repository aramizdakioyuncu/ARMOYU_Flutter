// ignore_for_file: avoid_print

// import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalApi {
  static const String oneSignalApiUrl =
      'https://onesignal.com/api/v1/'; // OneSignal API URL'si
  static const String oneSignalApiKey =
      'Y2ExNDY5MjAtMzlkOC00YzZkLTlkYTMtNTNhOWE0NzYzZmM5'; // OneSignal API anahtarınız

  // Yeni bir bildirim göndermek için bu metodu kullanabilirsiniz
  static Future<bool> sendNotification(
      {required String title, required String content, int? playerid}) async {
    final url = Uri.parse('${oneSignalApiUrl}notifications');
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic $oneSignalApiKey',
    };

    final notification = {
      'app_id':
          'c741c6f1-e84e-41d7-85b1-a596ffcfb5bd', // OneSignal uygulama kimliğinizi buraya ekleyin
      'name': "ARMOYU Mobile",
      'headings': {'en': title, 'tr': title},
      'contents': {'en': content, 'tr': content},
      // 'included_segments': ["Oyuncu"],
      "filters": [
        {"field": "tag", "key": "ID", "relation": "=", "value": "$playerid"}
      ]
    };

    final response =
        await http.post(url, headers: headers, body: json.encode(notification));
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Diğer OneSignal API işlemleri için gerekli metotları ekleyebilirsiniz

  static setupOneSignal(int ID, String username, String mail, String role) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("c741c6f1-e84e-41d7-85b1-a596ffcfb5bd");
    OneSignal.Notifications.requestPermission(true);

    OneSignal.login(username);
    OneSignal.User.setLanguage("tr");
    Map<String, dynamic> tags = {"ID": ID, "Role": role};
    OneSignal.User.addTags(tags);
    OneSignal.User.addEmail(mail);
    OneSignal.Location.setShared(true);
  }
}