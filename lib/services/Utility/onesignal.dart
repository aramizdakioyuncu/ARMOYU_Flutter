// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:flutter/material.dart';
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
    log(response.body);
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
    OneSignal.consentRequired(false);
    OneSignal.Notifications.clearAll();

    OneSignal.Notifications.requestPermission(true);

    OneSignal.login(username);
    OneSignal.User.setLanguage("tr");
    Map<String, dynamic> tags = {"ID": ID, "Role": role, "username": username};
    OneSignal.User.addTags(tags);

    OneSignal.Location.setShared(true);

    OneSignal.Notifications.addClickListener((event) {
      try {
        String jsonAdditionalData =
            json.encode(event.notification.additionalData);
        Map<String, dynamic> responseData = json.decode(jsonAdditionalData);

        log(event.notification.additionalData.toString());

        if (responseData["category"].toString() == "chat") {
          String avatar = "";
          String displayname = "";
          String userID = "";
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          AppCore.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                appbar: true,
                userID: int.parse(userID),
              ),
            ),
          );
        }
      } catch (e) {
        log("JSON Decode Hatası: $e");
      }
    });
  }
}
