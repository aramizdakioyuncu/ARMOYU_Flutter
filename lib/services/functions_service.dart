import 'dart:convert';

import 'package:armoyu/services/User.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

import 'dart:developer';

class FunctionService {
  /*
  
  
  
 */
  ApiService apiService = ApiService();

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

///////////Fonksiyonlar Başlangıcı
  Future<Map<String, dynamic>> login(String username, String password) async {
    password = generateMd5(password);

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
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('username', username);
      prefs.setString('password', password);

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
    User.banneravatar = response["parkaresimufak"];
    User.mail = response["eposta"];

    Map<String, dynamic> jsonData = {
      'durum': 1,
      'aciklama': "Başarılı.",
    };
    String jsonencode = jsonEncode(jsonData);
    Map<String, dynamic> jsonString = jsonData = json.decode(jsonencode);
    return jsonString;
  }

  Future<Map<String, dynamic>> myGroups() async {
    Map<String, String> formData = {"param1": "value1"};
    Map<String, dynamic> jsonData =
        await apiService.request("gruplarim/0/0", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> mySchools() async {
    Map<String, String> formData = {"param1": "value1"};
    Map<String, dynamic> jsonData =
        await apiService.request("okullarim/0/0", formData);
    return jsonData;
  }
}
