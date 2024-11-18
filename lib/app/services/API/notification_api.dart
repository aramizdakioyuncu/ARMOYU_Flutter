import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class NotificationAPI {
  final User currentUser;
  NotificationAPI({required this.currentUser});

  Future<Map<String, dynamic>> listNotificationSettings() async {
    return await API.service.notificationServices.listNotificationSettings(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> updateNotificationSettings({
    required List<String> options,
  }) async {
    return await API.service.notificationServices.updateNotificationSettings(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      options: options,
    );
  }
}
