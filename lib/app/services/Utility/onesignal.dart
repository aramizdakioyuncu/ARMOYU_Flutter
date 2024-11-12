// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/Chat/chat.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/event.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/group.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/Events/event_page/views/event_view.dart';
import 'package:get/get.dart';
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

  static setupOneSignal({required UserAccounts currentUserAccounts}) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(API.oneSignalKey);
    OneSignal.consentRequired(false);
    OneSignal.Notifications.clearAll();

    OneSignal.Notifications.requestPermission(true);

    OneSignal.login(currentUserAccounts.user.value.userName!);
    OneSignal.User.setLanguage("tr");
    Map<String, dynamic> tags = {
      "ID": currentUserAccounts.user.value.userID,
      "Role": currentUserAccounts.user.value.role!.name.toString(),
      "username": currentUserAccounts.user.value.userName,
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

          // AppCore.navigatorKey.currentState?.push(
          //   MaterialPageRoute(
          //     builder: (context) => ChatDetailPage(
          //       currentUserAccounts:
          //           UserAccounts(user: User(userName: "", password: "")),
          //       chat: Chat(
          //         user: User(userID: int.parse(userID)),
          //         chatNotification: false,
          //       ),
          //     ),
          //   ),
          // );

          Get.toNamed("/chat/detail", arguments: {
            "chat": Chat(
              user: User(userID: int.parse(userID)),
              chatNotification: false.obs,
            ),
          });
        } else if (responseData["category"].toString() == "profile") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          // AppCore.navigatorKey.currentState?.push(
          //   MaterialPageRoute(
          //     builder: (context) => ProfilePage(
          //       currentUserAccounts: currentUserAccounts,
          //       profileUser: User(userID: int.parse(userID)),
          //       ismyProfile: false,
          //       scrollController: ScrollController(),
          //     ),
          //   ),
          // );

          Get.to("/profile", arguments: {
            "profileUser": User(userID: int.parse(userID)),
          });
        } else if (responseData["category"].toString() == "group") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          // AppCore.navigatorKey.currentState?.push(
          //   MaterialPageRoute(
          //     builder: (context) => GroupPage(
          //       groupID: 1,
          //       group: Group(),
          //       currentUserAccounts:
          //           UserAccounts(user: (User(userID: int.parse(userID)))),
          //     ),
          //   ),
          // );

          Get.toNamed("/group/detail", arguments: {
            'user': User(userID: int.parse(userID)),
            'group': Group(groupID: 1)
          });
        } else if (responseData["category"].toString() == "post") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          // AppCore.navigatorKey.currentState?.push(
          //   MaterialPageRoute(
          //     builder: (context) => PostdetailView(),
          //   ),
          // );

          Get.toNamed("/social/detail", arguments: {"postID": 11});
        } else if (responseData["category"].toString() == "event") {
          for (Map<String, dynamic> element in responseData["content"]) {
            avatar = element["avatar"];
            displayname = element["displayname"];
            userID = element["userID"];
          }

          // AppCore.navigatorKey.currentState?.push(
          //   MaterialPageRoute(
          //     builder: (context) => EventPage(
          //       event: Event(
          //         eventID: 1,
          //       ),
          //       currentUserAccounts:
          //           UserAccounts(user: User(userID: int.parse(userID))),
          //     ),
          //   ),
          // );

          Get.to(
            EventView(
              currentUserAccounts:
                  UserAccounts(user: User(userID: int.parse(userID)).obs),
            ),
            arguments: {
              "event": Event(
                eventID: 1,
              ),
            },
          );
        }
      } catch (e) {
        log("JSON Decode Hatası: $e");
      }
    });
  }
}
