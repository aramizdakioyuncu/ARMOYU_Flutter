import 'dart:convert';
import 'dart:developer';
import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/chat/chat.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/event.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/group.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Chat/chat.dart';
import 'package:armoyu_widgets/data/models/user.dart';

import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
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

    OneSignal.Notifications.addClickListener((event) async {
      final findCurrentAccountController = Get.find<AccountUserController>();

      findCurrentAccountController.currentUserAccounts.value.user.value;

      log("---Onesignal-----${findCurrentAccountController.currentUserAccounts.value.user.value.userName}--------");
      try {
        String jsonAdditionalData =
            json.encode(event.notification.additionalData);
        Map<String, dynamic> responseData = json.decode(jsonAdditionalData);

        log("OneSignal | ${event.notification.additionalData}");

        log("OneSignal | Kategori: ${responseData["category"]}");

        if (responseData["category"].toString() == "chat") {
          dynamic categorydetail = responseData["categorydetail"];
          dynamic value = responseData["categoryvalue"];
          log("OneSignal | $categorydetail => $value");

          String? userDisplayname;
          String? userAvatar;
          int? userID;
          for (Map<String, dynamic> element in responseData["content"]) {
            userDisplayname = element["displayname"];
            userAvatar = element["avatar"];
            userID = element["userID"];
          }

          // await Future.delayed(Duration(seconds: 10)); // Örnek asenkron işlem
          Get.toNamed("/chat/detail", arguments: {
            "chat": Chat(
              chatType: APIChat.ozel,
              user: User(
                userID: userID!,
                displayName: Rx(userDisplayname!),
                avatar: Media(
                  mediaID: userID,
                  mediaType: MediaType.image,
                  mediaURL: MediaURL(
                    bigURL: Rx(userAvatar!),
                    normalURL: Rx(userAvatar),
                    minURL: Rx(userAvatar),
                  ),
                ),
              ),
              chatNotification: false.obs,
            )
          });
        } else if (responseData["category"].toString() == "profile") {
          dynamic categorydetail = responseData["categorydetail"];
          dynamic value = responseData["categoryvalue"];
          log("OneSignal | $categorydetail => $value");
          int? userID;

          for (Map<String, dynamic> element in responseData["content"]) {
            userID = element["userID"];
          }

          Get.toNamed("/profile", arguments: {
            "profileUser": User(userID: userID),
          });
        } else if (responseData["category"].toString() == "group") {
          dynamic categorydetail = responseData["categorydetail"];
          dynamic value = responseData["categoryvalue"];
          log("OneSignal | $categorydetail => $value");

          int? groupID;
          String? groupname;
          String? grouplogo;
          for (Map<String, dynamic> element in responseData["content"]) {
            groupID = element["groupID"];
            groupname = element["groupname"];
            grouplogo = element["grouplogo"];
          }

          log("$groupID $groupname $grouplogo");

          Get.toNamed("/group/detail", arguments: {
            'group': Group(groupID: groupID),
          });
        } else if (responseData["category"].toString() == "post") {
          dynamic categorydetail = responseData["categorydetail"];
          dynamic value = responseData["categoryvalue"];
          log("OneSignal | $categorydetail => $value");
          int? postID;
          for (Map<String, dynamic> element in responseData["content"]) {
            postID = element["postID"];
          }

          Get.toNamed("/social/detail", arguments: {"postID": postID});
        } else if (responseData["category"].toString() == "event") {
          dynamic categorydetail = responseData["categorydetail"];
          dynamic value = responseData["categoryvalue"];
          log("OneSignal | $categorydetail => $value");

          int? eventID;

          for (Map<String, dynamic> element in responseData["content"]) {
            eventID = element["eventID"];
          }

          Get.toNamed("/event/detail", arguments: {
            "event": Event(eventID: eventID!),
          });
        }
      } catch (e) {
        log("OneSignal JSON Decode Hatası: $e");
      }
    });
  }
}
