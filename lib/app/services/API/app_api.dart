import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class AppAPI {
  final User currentUser;
  AppAPI({required this.currentUser});

  Future<Map<String, dynamic>> sitemesaji() async {
    return await API.service.appServices.sitemesaji(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }
}
