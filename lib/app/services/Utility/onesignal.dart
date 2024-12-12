import 'dart:convert';
import 'dart:developer';
import 'package:ARMOYU/app/core/api.dart';

import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalApi {
  static const String oneSignalApiUrl = 'https://onesignal.com/api/v1/';
  static String oneSignalClientID = API.oneSignalClientID;
  static String oneSignalApiKey = API.oneSignalAPIKey;

  // Yeni bir bildirim göndermek için bu metodu kullanabilirsiniz
  static Future<bool> sendNotification(
      {required String title, required String content, int? playerid}) async {
    final url = Uri.parse('${oneSignalApiUrl}notifications');
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic $oneSignalApiKey',
    };

    final notification = {
      'app_id': oneSignalClientID,
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

  static setupOneSignal({required UserAccounts currentUserAccounts}) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(API.oneSignalClientID);
    OneSignal.consentRequired(false);
    OneSignal.Notifications.clearAll();

    OneSignal.Notifications.requestPermission(true);

    OneSignal.login(currentUserAccounts.user.value.userName!.value);
    OneSignal.User.setLanguage("tr");
    Map<String, dynamic> tags = {
      "ID": currentUserAccounts.user.value.userID,
      "Role": currentUserAccounts.user.value.role!.name.toString(),
      "username": currentUserAccounts.user.value.userName,
    };
    OneSignal.User.addTags(tags);

    OneSignal.Location.setShared(true);

    OneSignal.Notifications.addClickListener((event) {
      final findCurrentAccountController = Get.find<AccountUserController>();

      findCurrentAccountController.currentUserAccounts.value.user.value;

      log("${findCurrentAccountController.currentUserAccounts.value.user.value.userName}--------");
      try {
        String jsonAdditionalData =
            json.encode(event.notification.additionalData);
        Map<String, dynamic> responseData = json.decode(jsonAdditionalData);

        log(event.notification.additionalData.toString());

        log("Kategori: ${responseData["category"]}");

        String? userID;
        if (responseData["category"].toString() == "chat") {
          for (Map<String, dynamic> element in responseData["content"]) {
            userID = element["userID"];
          }
          log(userID.toString());
          // AppCore.navigatorKey.currentState?.push(

          // Get.toNamed("/chat/detail", arguments: {
          //   "chat": Chat(
          //     user: User(userID: int.parse(userID!)),
          //     chatNotification: false.obs,
          //   ),
          // });
        } else if (responseData["category"].toString() == "profile") {
          for (Map<String, dynamic> element in responseData["content"]) {
            userID = element["userID"];
          }

          // Get.toNamed("/profile", arguments: {
          //   "profileUser": User(userID: int.parse(userID!)),
          // });
        } else if (responseData["category"].toString() == "group") {
          for (Map<String, dynamic> element in responseData["content"]) {
            userID = element["userID"];
          }

          // Get.toNamed("/group/detail", arguments: {
          //   'user': User(userID: int.parse(userID!)),
          //   'group': Group(groupID: 1)
          // });
        } else if (responseData["category"].toString() == "post") {
          for (Map<String, dynamic> element in responseData["content"]) {
            userID = element["userID"];
          }

          // Get.toNamed("/social/detail", arguments: {"postID": 11});
        } else if (responseData["category"].toString() == "event") {
          for (Map<String, dynamic> element in responseData["content"]) {
            userID = element["userID"];
          }

          // Get.toNamed("/event/detail", arguments: {
          //   "event": Event(eventID: 1),
          // });
        }
      } catch (e) {
        log("JSON Decode Hatası: $e");
      }
    });
  }
}
