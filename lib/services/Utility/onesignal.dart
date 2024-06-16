// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Core/api.dart';
import 'package:ARMOYU/Models/Chat/chat.dart';
import 'package:ARMOYU/Models/event.dart';
import 'package:ARMOYU/Models/group.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Chat/chatdetail_page.dart';
import 'package:ARMOYU/Screens/Events/event_page.dart';
import 'package:ARMOYU/Screens/Group/group_page.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:ARMOYU/Screens/Social/postdetail_page.dart';
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

  static setupOneSignal({required User currentUser}) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(API.oneSignalKey);
    OneSignal.consentRequired(false);
    OneSignal.Notifications.clearAll();

    OneSignal.Notifications.requestPermission(true);

    OneSignal.login(currentUser.userName!);
    OneSignal.User.setLanguage("tr");
    Map<String, dynamic> tags = {
      "ID": currentUser.userID,
      "Role": currentUser.role!.name.toString(),
      "username": currentUser.userName,
    };
    OneSignal.User.addTags(tags);

    OneSignal.Location.setShared(true);

    OneSignal.Notifications.addClickListener((event) {
      try {
        String jsonAdditionalData =
            json.encode(event.notification.additionalData);
        Map<String, dynamic> responseData = json.decode(jsonAdditionalData);

        log(event.notification.additionalData.toString());

        log("Kategori: ${responseData["category"]}");
        String avatar = "";
        String displayname = "";
        String userID = "";
        if (responseData["category"].toString() == "chat") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          AppCore.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(
                chat: Chat(
                  user: User(userID: int.parse(userID)),
                  chatNotification: false,
                ),
              ),
            ),
          );
        } else if (responseData["category"].toString() == "profile") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          AppCore.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                ismyProfile: false,
                currentUser: User(userID: int.parse(userID)),
                scrollController: ScrollController(),
              ),
            ),
          );
        } else if (responseData["category"].toString() == "group") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          AppCore.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => GroupPage(
                groupID: 1,
                group: Group(),
                currentUser: User(userID: int.parse(userID)),
              ),
            ),
          );
        } else if (responseData["category"].toString() == "post") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          AppCore.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => const PostDetailPage(
                postID: 11,
              ),
            ),
          );
        } else if (responseData["category"].toString() == "event") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          AppCore.navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => EventPage(
                event: Event(
                  eventID: 1,
                ),
                currentUser: User(userID: int.parse(userID)),
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
