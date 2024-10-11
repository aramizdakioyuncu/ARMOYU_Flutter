import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';
import 'package:ARMOYU/app/Services/Utility/onesignal.dart';

class FunctionService {
  final User currentUser;
  late final ApiService apiService;

  FunctionService({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<Map<String, dynamic>> getappdetail() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("0/0/0/", formData);
    return jsonData;
  }

///////////Fonksiyonlar Başlangıcı

  Future<Map<String, dynamic>> adduserAccount(
    String username,
    String password,
  ) async {
    password = generateMd5(password);

    Map<String, String> formData = {"param1": "value1"};
    String link = "0/0/0/";

    Map<String, dynamic> response = await apiService.request(link, formData,
        username: username, password: password);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    Map<String, dynamic> oyuncubilgi = response["icerik"];

    User userdetail = ARMOYUFunctions.userfetch(oyuncubilgi);

    userdetail.password = password;

    int isUserAccountHas = ARMOYU.appUsers
        .indexWhere((element) => element.user.userID == userdetail.userID);

    if (isUserAccountHas != -1) {
      log("Zaten Kullanıcı Oturum Açmış!");
      return response;
    }
    ARMOYU.appUsers.add(UserAccounts(user: userdetail));

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

    Map<String, String> formData = {"param1": "value1"};
    String link = "0/0/0/";

    Map<String, dynamic> response = await apiService.request(link, formData,
        username: username, password: password);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    ARMOYU.version = response["aciklamadetay"]["versiyon"].toString();
    ARMOYU.securityDetail =
        response["aciklamadetay"]["projegizliliksozlesmesi"];

    Map<String, dynamic> oyuncubilgi = response["icerik"];

    UserAccounts userdetail =
        UserAccounts(user: ARMOYUFunctions.userfetch(oyuncubilgi));
    userdetail.user.password = password;

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

    userdetail.updateUser(targetUser: ARMOYU.appUsers.first.user);

    if (ARMOYU.deviceModel != "Bilinmeyen") {
      log("Onesignal işlemleri!");
      OneSignalApi.setupOneSignal(
        currentUserAccounts: userdetail,
      );
    }

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
    Map<String, String> formData = {
      "islem": "kayit-ol",
      "kullaniciadi": username,
      "ad": name,
      "soyad": lastname,
      "email": email,
      "parola": password,
      "parolakontrol": rpassword,
      "davetkodu": inviteCode,
    };
    Map<String, dynamic> jsonData =
        await apiService.request("kayit-ol/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> logOut(int userID) async {
    //Oturumunu Kapat
    ARMOYU.appUsers.removeWhere((element) => element.user.userID == userID);
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
    Map<String, String> formData = {
      // "dogumtarihi": "$userbirthday",
      "kullaniciadi": username,
      "email": useremail,
      "sifirlamatercihi": userresettype
    };
    Map<String, dynamic> jsonData =
        await apiService.request("sifremi-unuttum/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> forgotpassworddone(
      String username,
      String useremail,
      String securitycode,
      String password,
      String repassword) async {
    Map<String, String> formData = {
      // "dogumtarihi": "$userbirthday",
      "kullaniciadi": username,
      "email": useremail,
      "dogrulamakodu": securitycode,
      "sifre": password,
      "sifretekrar": repassword
    };
    Map<String, dynamic> jsonData =
        await apiService.request("sifremi-unuttum-dogrula/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> lookProfile(int userID) async {
    Map<String, String> formData = {"oyuncubakid": "$userID"};
    Map<String, dynamic> jsonData =
        await apiService.request("0/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> lookProfilewithusername(String username) async {
    Map<String, String> formData = {"oyuncubakusername": username};
    Map<String, dynamic> jsonData =
        await apiService.request("0/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> myGroups() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplarim/0/0", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> mySchools() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("okullarim/0/0", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> myStations() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("istasyonlarim/0/0", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getprofilePosts(
      int page, int userID, String category) async {
    Map<String, String> formData = {
      "oyuncubakid": "$userID",
      "limit": "20",
      "paylasimozellik": category,
    };
    Map<String, dynamic> jsonData =
        await apiService.request("sosyal/liste/$page/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getplayerxp(int page) async {
    Map<String, String> formData = {"sayfa": "$page"};
    Map<String, dynamic> jsonData =
        await apiService.request("xpsiralama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getplayerpop(int page) async {
    Map<String, String> formData = {"sayfa": "$page"};
    Map<String, dynamic> jsonData =
        await apiService.request("popsiralama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getnotifications(
      String kategori, String kategoridetay, int page) async {
    Map<String, String> formData = {
      "kategori": kategori,
      "kategoridetay": kategoridetay,
      "sayfa": "$page",
      "limit": "20"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("bildirimler/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getchats(int page) async {
    Map<String, String> formData = {"sayfa": "$page", "limit": "30"};
    Map<String, dynamic> jsonData =
        await apiService.request("sohbet/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getnewchatfriendlist(int page) async {
    Map<String, String> formData = {"sayfa": "$page", "limit": "30"};
    Map<String, dynamic> jsonData =
        await apiService.request("sohbet/arkadaslarim/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getdeailchats(int chatID) async {
    Map<String, String> formData = {
      "sohbetID": "$chatID",
      "sohbetturu": "ozel"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("sohbetdetay/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> sendchatmessage(
      int userID, String message, String type) async {
    Map<String, String> formData = {
      "oyuncubakid": "$userID",
      "icerik": message,
      "turu": type
    };
    Map<String, dynamic> jsonData =
        await apiService.request("sohbetgonder/0/0/", formData);
    return jsonData;
  }
}
