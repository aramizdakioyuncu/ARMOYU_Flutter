import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';

class LoginregisterAPI {
  final User currentUser;
  LoginregisterAPI({required this.currentUser});

  //////////////////////LOGINREGISTER////////////////////

  Future<LoginRegisterInviteCodeResponse> inviteCodeTest(
      {required String code}) async {
    return await API.service.loginRegisterServices.inviteCodeTest(code: code);
  }
}
