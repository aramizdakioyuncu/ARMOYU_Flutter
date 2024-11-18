import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/API/utils_api.dart';
import 'package:ARMOYU/app/services/socketio_services.dart';
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

  Future<Map<String, dynamic>> getappdetail() async {
    Map<String, dynamic> jsonData = await apiService.getappdetail();
    return jsonData;
  }

///////////Fonksiyonlar Başlangıcı

  Future<Map<String, dynamic>> adduserAccount(
    String username,
    String password,
  ) async {
    password = generateMd5(password);

    Map<String, dynamic> response =
        await apiService.previuslogin(username: username, password: password);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    Map<String, dynamic> oyuncubilgi = response["icerik"];

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
    Map<String, dynamic> response = await f.lookProfile(userID);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      return User();
    }

    Map<String, dynamic> oyuncubilgi = response["icerik"];

    User userdetail = ARMOYUFunctions.userfetch(oyuncubilgi);

    return userdetail;
  }

  Future<Map<String, dynamic>> login(
      String username, String password, bool system) async {
    if (!system) {
      password = generateMd5(password);
    }

    Map<String, dynamic> response =
        await apiService.previuslogin(username: username, password: password);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    ARMOYU.version = response["aciklamadetay"]["versiyon"].toString();
    ARMOYU.securityDetail =
        response["aciklamadetay"]["projegizliliksozlesmesi"];

    Map<String, dynamic> oyuncubilgi = response["icerik"];

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

    Map<String, dynamic> jsonData = {
      'durum': 1,
      'aciklama': "Başarılı.",
      'aciklamadetay': response["aciklamadetay"],
      'icerik': ARMOYU.appUsers.last.user.toJson()
    };
    String jsonencode = jsonEncode(jsonData);
    Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
    return jsonString;
  }

  Future<Map<String, dynamic>> register(
    String username,
    String name,
    String lastname,
    String email,
    String password,
    String rpassword,
    String inviteCode,
  ) async {
    Map<String, dynamic> jsonData = await apiService.previusregister(
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

  Future<Map<String, dynamic>> forgotpassword(
      String username, String useremail, String userresettype) async {
    Map<String, dynamic> jsonData = await apiService.forgotpassword(
      username: username,
      useremail: useremail,
      userresettype: userresettype,
    );
    return jsonData;
  }

  Future<Map<String, dynamic>> forgotpassworddone(
      String username,
      String useremail,
      String securitycode,
      String password,
      String repassword) async {
    Map<String, dynamic> jsonData = await apiService.forgotpassworddone(
      username: username,
      useremail: useremail,
      securitycode: securitycode,
      password: password,
      repassword: repassword,
    );
    return jsonData;
  }

  Future<Map<String, dynamic>> lookProfile(int userID) async {
    Map<String, dynamic> jsonData =
        await apiService.lookProfile(userID: userID.toString());
    return jsonData;
  }

  Future<Map<String, dynamic>> lookProfilewithusername(String username) async {
    Map<String, dynamic> jsonData =
        await apiService.lookProfilewithusername(userusername: username);
    return jsonData;
  }

  Future<Map<String, dynamic>> myGroups() async {
    Map<String, dynamic> jsonData = await apiService.myGroups();
    return jsonData;
  }

  Future<Map<String, dynamic>> mySchools() async {
    Map<String, dynamic> jsonData = await apiService.mySchools();
    return jsonData;
  }

  Future<Map<String, dynamic>> myStations() async {
    Map<String, dynamic> jsonData = await apiService.myStations();
    return jsonData;
  }

  Future<Map<String, dynamic>> getprofilePosts(
      int page, int userID, String category) async {
    Map<String, dynamic> jsonData = await apiService.getprofilePosts(
      userID: userID.toString(),
      page: page.toString(),
      category: category,
    );
    return jsonData;
  }

  Future<Map<String, dynamic>> getplayerxp(int page) async {
    Map<String, dynamic> jsonData = await apiService.getplayerxp(page: page);
    return jsonData;
  }

  Future<Map<String, dynamic>> getplayerpop(int page) async {
    Map<String, dynamic> jsonData = await apiService.getplayerpop(page: page);
    return jsonData;
  }

  Future<Map<String, dynamic>> getnotifications(
      String kategori, String kategoridetay, int page) async {
    Map<String, dynamic> jsonData = await apiService.getnotifications(
      kategori: kategori,
      kategoridetay: kategoridetay,
      page: page,
    );
    return jsonData;
  }

  Future<Map<String, dynamic>> getchats(int page) async {
    Map<String, dynamic> jsonData = await apiService.getchats(page: page);
    return jsonData;
  }

  Future<Map<String, dynamic>> getnewchatfriendlist(int page) async {
    Map<String, dynamic> jsonData =
        await apiService.getnewchatfriendlist(page: page);
    return jsonData;
  }

  Future<Map<String, dynamic>> getdeailchats(int chatID) async {
    Map<String, dynamic> jsonData =
        await apiService.getdeailchats(chatID: chatID);
    return jsonData;
  }

  Future<Map<String, dynamic>> sendchatmessage(
      int userID, String message, String type) async {
    Map<String, dynamic> jsonData = await apiService.sendchatmessage(
      userID: userID,
      message: message,
      type: type,
    );
    return jsonData;
  }
}
