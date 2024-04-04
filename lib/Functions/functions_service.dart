import 'dart:convert';
import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/team.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Chat/chat_page.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ARMOYU/Services/API/api_service.dart';
import 'package:ARMOYU/Services/Utility/onesignal.dart';

class FunctionService {
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
      String username, String password, bool system) async {
    if (!system) {
      password = generateMd5(password);
    }

    ARMOYU.Appuser.userName = username;
    ARMOYU.Appuser.password = password;

    Map<String, String> formData = {"param1": "value1"};
    String link = "0/0/0/";

    Map<String, dynamic> response = await apiService.request(link, formData);

    if (response["durum"] == 0 ||
        response["aciklama"] == "Oyuncu bilgileri yanlış!") {
      return response;
    }

    ARMOYU.version = response["aciklamadetay"]["versiyon"].toString();
    ARMOYU.securityDetail =
        response["aciklamadetay"]["projegizliliksozlesmesi"];

    Map<String, dynamic> oyuncubilgi = response["icerik"];
    ARMOYU.Appuser = User(
        userID: oyuncubilgi["oyuncuID"],
        userName: oyuncubilgi["kullaniciadi"],
        password: password,
        firstName: oyuncubilgi["adi"],
        lastName: oyuncubilgi["soyadi"],
        displayName: oyuncubilgi["adim"],
        userMail: oyuncubilgi["eposta"],
        aboutme: oyuncubilgi["hakkimda"],
        avatar: Media(
          mediaID: oyuncubilgi["presimID"],
          ownerID: oyuncubilgi["oyuncuID"],
          mediaURL: MediaURL(
            bigURL: oyuncubilgi["presim"],
            normalURL: oyuncubilgi["presimufak"],
            minURL: oyuncubilgi["presimminnak"],
          ),
        ),
        banner: Media(
          mediaID: oyuncubilgi["parkaresimID"],
          ownerID: oyuncubilgi["oyuncuID"],
          mediaURL: MediaURL(
            bigURL: oyuncubilgi["parkaresim"],
            normalURL: oyuncubilgi["parkaresimufak"],
            minURL: oyuncubilgi["parkaresimminnak"],
          ),
        ),
        burc: oyuncubilgi["burc"],
        invitecode: oyuncubilgi["davetkodu"],
        lastlogin: oyuncubilgi["songiris"],
        lastfaillogin: oyuncubilgi["sonhataligiris"],
        job: oyuncubilgi["isyeriadi"],
        level: oyuncubilgi["seviye"],
        levelColor: oyuncubilgi["seviyerenk"],
        xp: oyuncubilgi["seviyexp"],
        awardsCount: oyuncubilgi["oduller"],
        postsCount: oyuncubilgi["gonderiler"],
        friendsCount: oyuncubilgi["arkadaslar"],
        country: oyuncubilgi["ulkesi"],
        province: oyuncubilgi["ili"],
        registerDate: oyuncubilgi["kayittarihikisa"],
        role: oyuncubilgi["yetkisiacikla"],
        rolecolor: oyuncubilgi["yetkirenk"],
        favTeam: oyuncubilgi["favoritakim"] != null
            ? Team(
                teamID: oyuncubilgi["favoritakim"]["takim_ID"],
                name: oyuncubilgi["favoritakim"]["takim_adi"],
                logo: oyuncubilgi["favoritakim"]["takim_logo"],
              )
            : null);

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('username', username);
    prefs.setString('password', password);

    if (ARMOYU.deviceModel != "Bilinmeyen") {
      log("Onesignal işlemleri!");
      OneSignalApi.setupOneSignal(
        ARMOYU.Appuser.userID!,
        ARMOYU.Appuser.userName!,
        ARMOYU.Appuser.userMail!,
        ARMOYU.Appuser.role.toString(),
      );
    }

    Map<String, dynamic> jsonData = {
      'durum': 1,
      'aciklama': "Başarılı.",
      'aciklamadetay': response["aciklamadetay"],
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

  Future<Map<String, dynamic>> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    ARMOYU.Appuser.userID = null;
    ARMOYU.Appuser.userName = "0";
    ARMOYU.Appuser.password = "0";
    chatlist.clear();
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
