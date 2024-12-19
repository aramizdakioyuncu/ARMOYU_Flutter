import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/socketio_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:ARMOYU/app/Services/Utility/onesignal.dart';

class FunctionService {
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<ServiceResult> getappdetail() async {
    ServiceResult jsonData = await API.service.utilsServices.getappdetail();
    return jsonData;
  }

///////////Fonksiyonlar Başlangıcı

  Future<LoginResponse> adduserAccount(
    String username,
    String userpass,
  ) async {
    // password = generateMd5(password);

    LoginResponse response = await API.service.authServices
        .login(username: username, password: userpass);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    APILogin oyuncubilgi = response.response!;

    User userdetail = ARMOYUFunctions.userfetch(oyuncubilgi);

    int isUserAccountHas = ARMOYU.appUsers.indexWhere(
        (element) => element.user.value.userID == userdetail.userID);

    if (isUserAccountHas != -1) {
      log("Zaten Kullanıcı Oturum Açmış!");
      return response;
    }
    ARMOYU.appUsers.add(
      UserAccounts(
        user: userdetail.obs,
        sessionTOKEN: Rx(response.result.description),
        language: Rx(""),
      ),
    );

    // Kullanıcı listesini Storeage'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    ARMOYU.storage.write("users", usersJson);
    // Kullanıcı listesini Storeage'e kaydetme
    return response;
  }

  Future<User?> fetchUserInfo({required int userID}) async {
    FunctionService f = FunctionService();
    LookProfileResponse response = await f.lookProfile(userID);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return User();
    }

    User userdetail = ARMOYUFunctions.userfetch(response.response!);

    return userdetail;
  }

  Future<LoginResponse> login(String username, String password) async {
    LoginResponse response = await API.service.authServices
        .login(username: username, password: password);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    ARMOYU.version = response.result.descriptiondetail["versiyon"].toString();
    ARMOYU.securityDetail =
        response.result.descriptiondetail["projegizliliksozlesmesi"];

    APILogin oyuncubilgi = response.response!;

    UserAccounts userdetail = UserAccounts(
      user: ARMOYUFunctions.userfetch(oyuncubilgi).obs,
      sessionTOKEN: Rx(response.result.description),
      language: Rx(""),
    );

    //İlk defa giriş yapılıyorsa
    if (ARMOYU.appUsers.isEmpty) {
      ARMOYU.appUsers.add(userdetail);
    }

    // Kullanıcı listesini Storeage'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    ARMOYU.storage.write("users", usersJson);
    // Kullanıcı listesini Storeage'e kaydetme

    userdetail.updateUser(targetUser: ARMOYU.appUsers.first.user.value);

    if (ARMOYU.deviceModel != "Bilinmeyen") {
      log("Onesignal işlemleri!");
      OneSignalApi.setupOneSignal(
        currentUserAccounts: userdetail,
      );
    }

    //Socket Güncelle
    var socketio = Get.find<SocketioController>();
    socketio.registerUser(userdetail.user.value);
    //Socket Güncelle

    LoginResponse ll = LoginResponse(
      result: ServiceResult(
        status: true,
        description: "Başarılı",
        descriptiondetail: response.result.descriptiondetail,
      ),
      response: oyuncubilgi,
    );

    return ll;
  }

  Future<RegisterResponse> register(
    String username,
    String name,
    String lastname,
    String email,
    String password,
    String rpassword,
    String inviteCode,
  ) async {
    RegisterResponse jsonData = await API.service.authServices.register(
      username: username,
      firstname: name,
      lastname: lastname,
      email: email,
      password: password,
      rpassword: rpassword,
      inviteCode: inviteCode,
    );
    return jsonData;
  }

  Future<Map<String, dynamic>> logOut(int userID) async {
    //Oturumunu Kapat
    ARMOYU.appUsers
        .removeWhere((element) => element.user.value.userID == userID);
    //Oturumunu Kapat Bitiş

    // Kullanıcı listesini Storeage'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    ARMOYU.storage.write("users", usersJson);
    // Kullanıcı listesini Storeage'e kaydetme
    //
    Map<String, dynamic> jsonData = {
      'durum': 1,
      'aciklama': "Başarılı bir şekilde çıkış yapıldı.",
    };
    String jsonencode = jsonEncode(jsonData);
    Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
    return jsonString;
  }

  Future<ServiceResult> forgotpassword(
      String username, String useremail, String userresettype) async {
    ServiceResult jsonData = await API.service.utilsServices.forgotpassword(
      username: username,
      useremail: useremail,
      userresettype: userresettype,
    );
    return jsonData;
  }

  Future<ServiceResult> forgotpassworddone(String username, String useremail,
      String securitycode, String password, String repassword) async {
    ServiceResult jsonData = await API.service.utilsServices.forgotpassworddone(
      username: username,
      useremail: useremail,
      securitycode: securitycode,
      password: password,
      repassword: repassword,
    );
    return jsonData;
  }

  Future<LookProfileResponse> lookProfile(int userID) async {
    LookProfileResponse jsonData =
        await API.service.utilsServices.lookProfile(userID: userID);
    return jsonData;
  }

  Future<LookProfilewithUsernameResponse> lookProfilewithusername(
      String username) async {
    LookProfilewithUsernameResponse jsonData = await API.service.utilsServices
        .lookProfilewithusername(userusername: username);
    return jsonData;
  }

  Future<APIMyGroupListResponse> myGroups() async {
    APIMyGroupListResponse jsonData =
        await API.service.utilsServices.myGroups();
    return jsonData;
  }

  Future<APIMySchoolListResponse> mySchools() async {
    APIMySchoolListResponse jsonData =
        await API.service.utilsServices.mySchools();
    return jsonData;
  }

  Future<ServiceResult> myStations() async {
    ServiceResult jsonData = await API.service.utilsServices.myStations();
    return jsonData;
  }

  Future<PostFetchListResponse> getprofilePosts(
      int page, int userID, String category) async {
    PostFetchListResponse jsonData =
        await API.service.postsServices.getprofilePosts(
      userID: userID.toString(),
      page: page,
      category: category,
    );
    return jsonData;
  }

  Future<PlayerPopResponse> getplayerxp(int page) async {
    PlayerPopResponse jsonData =
        await API.service.utilsServices.getplayerxp(page: page);
    return jsonData;
  }

  Future<PlayerPopResponse> getplayerpop(int page) async {
    PlayerPopResponse jsonData =
        await API.service.utilsServices.getplayerpop(page: page);
    return jsonData;
  }

  Future<NotificationListResponse> getnotifications(
      String kategori, String kategoridetay, int page) async {
    NotificationListResponse jsonData =
        await API.service.notificationServices.getnotifications(
      kategori: kategori,
      kategoridetay: kategoridetay,
      page: page,
    );
    return jsonData;
  }

  Future<ChatListResponse> getchats(int page) async {
    ChatListResponse jsonData =
        await API.service.utilsServices.getchats(page: page);
    return jsonData;
  }

  Future<ServiceResult> getnewchatfriendlist(int page) async {
    ServiceResult jsonData =
        await API.service.utilsServices.getnewchatfriendlist(page: page);
    return jsonData;
  }

  Future<ChatFetchDetailResponse> getdeailchats(int chatID) async {
    ChatFetchDetailResponse jsonData =
        await API.service.utilsServices.getdetailchats(chatID: chatID);
    return jsonData;
  }

  Future<ServiceResult> sendchatmessage(
      int userID, String message, String type) async {
    ServiceResult jsonData = await API.service.utilsServices.sendchatmessage(
      userID: userID,
      message: message,
      type: type,
    );
    return jsonData;
  }
}
