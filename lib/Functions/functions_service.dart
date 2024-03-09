// ignore_for_file: non_constant_identifier_names, prefer_if_null_operators

import 'dart:convert';

import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Services/appuser.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Services/API/api_service.dart';
import 'package:ARMOYU/Services/Utility/onesignal.dart';

class FunctionService {
  /*
  
  
  
 */
  ApiService apiService = ApiService();

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
  Future<Map<String, dynamic>> login(
      String username, String password, bool System) async {
    if (!System) {
      password = generateMd5(password);
    }

    if (username == "" || password == "") {
      Map<String, dynamic> jsonData = {
        'durum': 0,
        'aciklama': "Kullanıcı adı veya Parola boş olamaz!",
      };
      String jsonencode = jsonEncode(jsonData);
      Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
      return jsonString;
    }

    AppUser.userName = username;
    AppUser.password = password;

    Map<String, String> formData = {"param1": "value1"};
    String link = "0/0/0/";

    Map<String, dynamic> response = await apiService.request(link, formData);
    if (response["durum"].toString() != "1") {
      Map<String, dynamic> jsonData = {
        'durum': 0,
        'aciklama': "Sunucuya ulaşamadı!",
      };
      String jsonencode = jsonEncode(jsonData);
      Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
      return jsonString;
    }
    if (response["kontrol"].toString() != "1") {
      Map<String, dynamic> jsonData = {
        'durum': 0,
        'aciklama': "Hatalı giriş!",
      };
      String jsonencode = jsonEncode(jsonData);
      Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
      return jsonString;
    }

    AppUser.ID = int.parse(response["oyuncuID"]);
    AppUser.userName = response["kullaniciadi"];
    AppUser.firstName = response["adi"];
    AppUser.lastName = response["soyadi"];
    AppUser.displayName = response["adim"];
    AppUser.avatar = response["presimminnak"];
    AppUser.avatarbetter = response["presimufak"];
    AppUser.banneravatar = response["parkaresimminnak"];
    AppUser.banneravatarbetter = response["parkaresimufak"];

    AppUser.level = response["seviye"];
    AppUser.friendsCount = response["arkadaslar"];
    AppUser.postsCount = response["gonderiler"];
    AppUser.awardsCount = response["oduller"];

    AppUser.mail = response["eposta"];

    AppUser.country = response["ulkesi"] == null ? "" : response["ulkesi"];
    AppUser.province = response["ili"] == null ? "" : response["ili"];
    AppUser.registerdate = response["kayittarihikisa"];

    if (response["isyeriadi"] != null) {
      AppUser.job = response["isyeriadi"];
    }
    AppUser.role = response["yetkisiacikla"];
    AppUser.rolecolor = response["yetkirenk"];

    AppUser.aboutme = response["hakkimda"];
    AppUser.burc = response["burc"] == null ? "" : response["burc"];

    if (response["favoritakim"] != null) {
      AppUser.favTeam = Team(
        teamID: response["favoritakim"]["takim_ID"],
        name: response["favoritakim"]["takim_adi"],
        logo: response["favoritakim"]["takim_logo"],
      );
    }

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('username', username);
    prefs.setString('password', password);

    // App.getDeviceModel
    AppCore app = AppCore();
    String cevap = app.getDevice();

    if (cevap != "Bilinmeyen") {
      OneSignalApi.setupOneSignal(
          AppUser.ID, AppUser.userName, AppUser.mail, AppUser.role.toString());
    }

    Map<String, dynamic> jsonData = {
      'durum': 1,
      'aciklama': "Başarılı.",
    };
    String jsonencode = jsonEncode(jsonData);
    Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
    return jsonString;
  }

  Future<Map<String, dynamic>> register(String username, String name,
      String lastname, String email, String password, String rpassword) async {
    Map<String, String> formData = {
      "islem": "kayit-ol",
      "kullaniciadi": username,
      "ad": name,
      "soyad": lastname,
      "email": email,
      "parola": password,
      "parolakontrol": rpassword
    };
    Map<String, dynamic> jsonData =
        await apiService.request("kayit-ol/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    AppUser.userName = "0";
    AppUser.password = "0";

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

  Future<Map<String, dynamic>> getPosts(int page) async {
    Map<String, String> formData = {"limit": "20"};
    Map<String, dynamic> jsonData =
        await apiService.request("sosyal/liste/$page/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getprofilePosts(int page, int UserID) async {
    Map<String, String> formData = {"oyuncubakid": "$UserID", "limit": "20"};
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

  Future<Map<String, dynamic>> getnotifications(int page) async {
    Map<String, String> formData = {"sayfa": "$page", "limit": "20"};
    Map<String, dynamic> jsonData =
        await apiService.request("bildirimler/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getchats(int page) async {
    Map<String, String> formData = {"sayfa": "$page"};
    Map<String, dynamic> jsonData =
        await apiService.request("sohbet/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getnewchatfriendlist(int page) async {
    Map<String, String> formData = {"sayfa": "$page"};
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
