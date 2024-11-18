import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class LoginregisterAPI {
  final User currentUser;
  LoginregisterAPI({required this.currentUser});

  //////////////////////LOGINREGISTER////////////////////

  Future<Map<String, dynamic>> inviteCodeTest({required String code}) async {
    return await API.service.loginRegisterServices.inviteCodeTest(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      code: code,
    );
  }
}
