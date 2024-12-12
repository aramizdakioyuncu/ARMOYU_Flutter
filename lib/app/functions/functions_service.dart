import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/API/utils_api.dart';
import 'package:ARMOYU/app/services/socketio_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/login&register&password/login.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ARMOYU/app/Services/Utility/onesignal.dart';

class FunctionService {
  final User currentUser;
  late final UtilsAPI apiService;

  FunctionService({required this.currentUser}) {
    apiService = UtilsAPI(currentUser: currentUser);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<ServiceResult> getappdetail() async {
    ServiceResult jsonData = await apiService.getappdetail();
    return jsonData;
  }

///////////Fonksiyonlar Başlangıcı

  Future<LoginResponse> adduserAccount(
    String username,
    String password,
  ) async {
    password = generateMd5(password);

    LoginResponse response =
        await apiService.previuslogin(username: username, password: password);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    APILogin oyuncubilgi = response.response!;

    User userdetail = ARMOYUFunctions.userfetch(oyuncubilgi);

    userdetail.password = password.obs;

    int isUserAccountHas = ARMOYU.appUsers.indexWhere(
        (element) => element.user.value.userID == userdetail.userID);

    if (isUserAccountHas != -1) {
      log("Zaten Kullanıcı Oturum Açmış!");
      return response;
    }
    ARMOYU.appUsers.add(UserAccounts(user: userdetail.obs));

    // Kullanıcı listesini SharedPreferences'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('users', usersJson);
    //
    return response;
  }

  Future<User?> fetchUserInfo({required int userID}) async {
    FunctionService f = FunctionService(currentUser: currentUser);
    LookProfileResponse response = await f.lookProfile(userID);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return User();
    }

    User userdetail = ARMOYUFunctions.userfetch(response.response!);

    return userdetail;
  }

  Future<LoginResponse> login(
      String username, String password, bool system) async {
    if (!system) {
      password = generateMd5(password);
    }

    LoginResponse response =
        await apiService.previuslogin(username: username, password: password);

    if (!response.result.status ||
        response.result.description == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    ARMOYU.version = response.result.descriptiondetail["versiyon"].toString();
    ARMOYU.securityDetail =
        response.result.descriptiondetail["projegizliliksozlesmesi"];

    APILogin oyuncubilgi = response.response!;

    UserAccounts userdetail =
        UserAccounts(user: ARMOYUFunctions.userfetch(oyuncubilgi).obs);
    userdetail.user.value.password = password.obs;

    //İlk defa giriş yapılıyorsa
    if (ARMOYU.appUsers.isEmpty) {
      ARMOYU.appUsers.add(userdetail);
    }

    // Kullanıcı listesini SharedPreferences'e kaydetme
    final prefs = await SharedPreferences.getInstance();

    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    prefs.setStringList('users', usersJson);
    //

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

    // Map<String, dynamic> jsonData = {
    //   'durum': 1,
    //   'aciklama': "Başarılı.",
    //   'aciklamadetay': response.result.descriptiondetail,
    //   'icerik': ARMOYU.appUsers.last.user.toJson()
    // };

    LoginResponse ll = LoginResponse(
      result: ServiceResult(
        status: true,
        description: "Başarılı",
        descriptiondetail: response.result.descriptiondetail,
      ),
      response: ARMOYU.appUsers.last.user.toJson(),
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
    RegisterResponse jsonData = await apiService.previusregister(
      username: username,
      name: name,
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

    // Kullanıcı listesini SharedPreferences'e kaydetme
    List<String> usersJson =
        ARMOYU.appUsers.map((user) => jsonEncode(user.toJson())).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('users', usersJson);
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
    ServiceResult jsonData = await apiService.forgotpassword(
      username: username,
      useremail: useremail,
      userresettype: userresettype,
    );
    return jsonData;
  }

  Future<ServiceResult> forgotpassworddone(String username, String useremail,
      String securitycode, String password, String repassword) async {
    ServiceResult jsonData = await apiService.forgotpassworddone(
      username: username,
      useremail: useremail,
      securitycode: securitycode,
      password: password,
      repassword: repassword,
    );
    return jsonData;
  }

  Future<LookProfileResponse> lookProfile(int userID) async {
    LookProfileResponse jsonData = await apiService.lookProfile(userID: userID);
    return jsonData;
  }

  Future<LookProfilewithUsernameResponse> lookProfilewithusername(
      String username) async {
    LookProfilewithUsernameResponse jsonData =
        await apiService.lookProfilewithusername(userusername: username);
    return jsonData;
  }

  Future<APIMyGroupListResponse> myGroups() async {
    APIMyGroupListResponse jsonData = await apiService.myGroups();
    return jsonData;
  }

  Future<APIMySchoolListResponse> mySchools() async {
    APIMySchoolListResponse jsonData = await apiService.mySchools();
    return jsonData;
  }

  Future<ServiceResult> myStations() async {
    ServiceResult jsonData = await apiService.myStations();
    return jsonData;
  }

  Future<PostFetchListResponse> getprofilePosts(
      int page, int userID, String category) async {
    PostFetchListResponse jsonData = await apiService.getprofilePosts(
      userID: userID.toString(),
      page: page,
      category: category,
    );
    return jsonData;
  }

  Future<PlayerPopResponse> getplayerxp(int page) async {
    PlayerPopResponse jsonData = await apiService.getplayerxp(page: page);
    return jsonData;
  }

  Future<PlayerPopResponse> getplayerpop(int page) async {
    PlayerPopResponse jsonData = await apiService.getplayerpop(page: page);
    return jsonData;
  }

  Future<NotificationListResponse> getnotifications(
      String kategori, String kategoridetay, int page) async {
    NotificationListResponse jsonData = await apiService.getnotifications(
      kategori: kategori,
      kategoridetay: kategoridetay,
      page: page,
    );
    return jsonData;
  }

  Future<ChatListResponse> getchats(int page) async {
    ChatListResponse jsonData = await apiService.getchats(page: page);
    return jsonData;
  }

  Future<ServiceResult> getnewchatfriendlist(int page) async {
    ServiceResult jsonData = await apiService.getnewchatfriendlist(page: page);
    return jsonData;
  }

  Future<ChatFetchDetailResponse> getdeailchats(int chatID) async {
    ChatFetchDetailResponse jsonData =
        await apiService.getdeailchats(chatID: chatID);
    return jsonData;
  }

  Future<ServiceResult> sendchatmessage(
      int userID, String message, String type) async {
    ServiceResult jsonData = await apiService.sendchatmessage(
      userID: userID,
      message: message,
      type: type,
    );
    return jsonData;
  }
}
