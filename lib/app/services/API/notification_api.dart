import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class NotificationAPI {
  final User currentUser;
  NotificationAPI({required this.currentUser});

  Future<NotificationSettingsResponse> listNotificationSettings() async {
    return await API.service.notificationServices.listNotificationSettings();
  }

  Future<NotificationSettingsUpdateResponse> updateNotificationSettings(
      {required List<String> options}) async {
    return await API.service.notificationServices.updateNotificationSettings(
      options: options,
    );
  }
}
