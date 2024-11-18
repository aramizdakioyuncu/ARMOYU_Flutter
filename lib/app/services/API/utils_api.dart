import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class UtilsAPI {
  final User currentUser;
  UtilsAPI({required this.currentUser});

  Future<Map<String, dynamic>> getappdetail() async {
    return await API.service.utilsServices.getappdetail(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> fetchUserInfo({required int userID}) async {
    return await API.service.utilsServices.fetchUserInfo(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
  }

  Future<Map<String, dynamic>> previuslogin(
      {required String username, required String password}) async {
    return await API.service.authServices.previuslogin(
      username: username,
      password: password,
    );
  }

  Future<Map<String, dynamic>> previusregister({
    required String username,
    required String name,
    required String lastname,
    required String email,
    required String password,
    required String rpassword,
    required String inviteCode,
  }) async {
    return await API.service.authServices.previusregister(
      username: username,
      password: password,
      name: name,
      lastname: lastname,
      email: email,
      rpassword: rpassword,
      inviteCode: inviteCode,
    );
  }

  Future<Map<String, dynamic>> previuslogOut() async {
    return await API.service.authServices.previuslogOut(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> forgotpassword({
    required String username,
    required String useremail,
    required String userresettype,
  }) async {
    return await API.service.utilsServices.forgotpassword(
      username: username,
      password: currentUser.password!.value,
      useremail: useremail,
      userresettype: userresettype,
    );
  }

  Future<Map<String, dynamic>> forgotpassworddone({
    required String username,
    required String password,
    required String useremail,
    required String securitycode,
    required String repassword,
  }) async {
    return await API.service.utilsServices.forgotpassworddone(
      username: username,
      password: password,
      useremail: useremail,
      securitycode: securitycode,
      repassword: repassword,
    );
  }

  Future<Map<String, dynamic>> lookProfile({
    required String userID,
  }) async {
    return await API.service.utilsServices.lookProfile(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
    );
  }

  Future<Map<String, dynamic>> lookProfilewithusername({
    required String userusername,
  }) async {
    return await API.service.utilsServices.lookProfilewithusername(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userusername: userusername,
    );
  }

  Future<Map<String, dynamic>> myGroups() async {
    return await API.service.utilsServices.myGroups(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> mySchools() async {
    return await API.service.utilsServices.mySchools(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> myStations() async {
    return await API.service.utilsServices.myStations(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
    );
  }

  Future<Map<String, dynamic>> getprofilePosts({
    required String userID,
    required String category,
    required String page,
  }) async {
    return await API.service.utilsServices.getprofilePosts(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
      category: category,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getplayerxp({
    required int page,
  }) async {
    return await API.service.utilsServices.getplayerxp(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getplayerpop({
    required int page,
  }) async {
    return await API.service.utilsServices.getplayerpop(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getnotifications({
    required String kategori,
    required String kategoridetay,
    required int page,
  }) async {
    return await API.service.utilsServices.getnotifications(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      kategori: kategori,
      kategoridetay: kategoridetay,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getchats({required int page}) async {
    return await API.service.utilsServices.getchats(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getnewchatfriendlist({required int page}) async {
    return await API.service.utilsServices.getnewchatfriendlist(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getdeailchats({required int chatID}) async {
    return await API.service.utilsServices.getdeailchats(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      chatID: chatID,
    );
  }

  Future<Map<String, dynamic>> sendchatmessage({
    required int userID,
    required String message,
    required String type,
  }) async {
    return await API.service.utilsServices.sendchatmessage(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      userID: userID,
      message: message,
      type: type,
    );
  }
}
