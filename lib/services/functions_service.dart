// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';

import 'package:ARMOYU/Services/User.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Core/App_core.dart';
import 'api_service.dart';
import 'onesignal.dart';

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

    User.userName = username;
    User.password = password;

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

    User.ID = int.parse(response["oyuncuID"]);

    User.firstName = response["adi"];
    User.lastName = response["soyadi"];
    User.displayName = response["adim"];
    User.avatar = response["presimminnak"];
    User.avatarbetter = response["presimufak"];
    User.banneravatar = response["parkaresimminnak"];
    User.banneravatarbetter = response["parkaresimufak"];
    User.mail = response["eposta"];

    User.country = response["ulkesi"];
    User.province = response["ili"];
    User.registerdate = response["kayittarihikisa"];
    User.job = response["isyeriadi"];
    User.role = response["yetkisiacikla"];
    User.rolecolor = response["yetkirenk"];

    User.aboutme = response["hakkimda"];
    User.burc = response["burc"];

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('username', username);
    prefs.setString('password', password);

    // App.getDeviceModel
    AppCore app = AppCore();
    String cevap = app.getDevice();

    if (cevap != "Bilinmeyen") {
      OneSignalApi.setupOneSignal(
          User.ID, User.userName, User.mail, User.role.toString());
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
      "kullaniciadi": "$username",
      "ad": "$name",
      "soyad": "$lastname",
      "email": "$email",
      "parola": "$password",
      "parolakontrol": "$rpassword"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("kayit-ol/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    User.userName = "0";
    User.password = "0";

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
      "kullaniciadi": "$username",
      "email": "$useremail",
      "sifirlamatercihi": "$userresettype"
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
      "kullaniciadi": "$username",
      "email": "$useremail",
      "dogrulamakodu": "$securitycode",
      "sifre": "$password",
      "sifretekrar": "$repassword"
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
    Map<String, String> formData = {"oyuncubakusername": "$username"};
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
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("sosyal/liste/$page/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getprofilePosts(int page, UserID) async {
    Map<String, String> formData = {"oyuncubakid": "$UserID"};
    Map<String, dynamic> jsonData =
        await apiService.request("sosyal/liste/$page/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getplayerxp() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("xpsiralama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getplayerpop() async {
    Map<String, String> formData = {};
    Map<String, dynamic> jsonData =
        await apiService.request("popsiralama/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> getnotifications(int page) async {
    Map<String, String> formData = {"sayfa": "$page"};
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
      "icerik": "$message",
      "turu": "$type"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("sohbetgonder/0/0/", formData);
    return jsonData;
  }
}
