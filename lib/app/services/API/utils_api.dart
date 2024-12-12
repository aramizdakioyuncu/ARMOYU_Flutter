import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

class UtilsAPI {
  final User currentUser;
  UtilsAPI({required this.currentUser});

  Future<ServiceResult> getappdetail() async {
    return await API.service.utilsServices.getappdetail();
  }

  Future<ServiceResult> fetchUserInfo({required int userID}) async {
    return await API.service.utilsServices.fetchUserInfo(userID: userID);
  }

  Future<LoginResponse> previuslogin({
    required String username,
    required String password,
  }) async {
    return await API.service.authServices.login(
      username: username,
      password: password,
    );
  }

  Future<RegisterResponse> previusregister({
    required String username,
    required String name,
    required String lastname,
    required String email,
    required String password,
    required String rpassword,
    required String inviteCode,
  }) async {
    return await API.service.authServices.register(
      username: username,
      password: password,
      firstname: name,
      lastname: lastname,
      email: email,
      rpassword: rpassword,
      inviteCode: inviteCode,
    );
  }

  Future<Map<String, dynamic>> previuslogOut() async {
    return await API.service.authServices.logOut();
  }

  Future<ServiceResult> forgotpassword({
    required String username,
    required String useremail,
    required String userresettype,
  }) async {
    return await API.service.utilsServices.forgotpassword(
      username: username,
      useremail: useremail,
      userresettype: userresettype,
    );
  }

  Future<ServiceResult> forgotpassworddone({
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

  Future<LookProfileResponse> lookProfile({required int userID}) async {
    return await API.service.utilsServices.lookProfile(userID: userID);
  }

  Future<LookProfilewithUsernameResponse> lookProfilewithusername(
      {required String userusername}) async {
    return await API.service.utilsServices
        .lookProfilewithusername(userusername: userusername);
  }

  Future<APIMyGroupListResponse> myGroups() async {
    return await API.service.utilsServices.myGroups();
  }

  Future<APIMySchoolListResponse> mySchools() async {
    return await API.service.utilsServices.mySchools();
  }

  Future<ServiceResult> myStations() async {
    return await API.service.utilsServices.myStations();
  }

  Future<PostFetchListResponse> getprofilePosts({
    required String userID,
    required String category,
    required int page,
  }) async {
    return await API.service.postsServices.getprofilePosts(
      userID: userID,
      category: category,
      page: page,
    );
  }

  Future<PlayerPopResponse> getplayerxp({required int page}) async {
    return await API.service.utilsServices.getplayerxp(page: page);
  }

  Future<PlayerPopResponse> getplayerpop({required int page}) async {
    return await API.service.utilsServices.getplayerpop(page: page);
  }

  Future<NotificationListResponse> getnotifications({
    required String kategori,
    required String kategoridetay,
    required int page,
  }) async {
    return await API.service.notificationServices.getnotifications(
      kategori: kategori,
      kategoridetay: kategoridetay,
      page: page,
    );
  }

  Future<ChatListResponse> getchats({required int page}) async {
    return await API.service.utilsServices.getchats(page: page);
  }

  Future<ServiceResult> getnewchatfriendlist({required int page}) async {
    return await API.service.utilsServices.getnewchatfriendlist(page: page);
  }

  Future<ChatFetchDetailResponse> getdeailchats({required int chatID}) async {
    return await API.service.utilsServices.getdetailchats(chatID: chatID);
  }

  Future<ServiceResult> sendchatmessage({
    required int userID,
    required String message,
    required String type,
  }) async {
    return await API.service.utilsServices.sendchatmessage(
      userID: userID,
      message: message,
      type: type,
    );
  }
}
