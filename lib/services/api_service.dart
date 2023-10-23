import 'dart:convert';
import 'dart:developer';
import 'package:ARMOYU/Core/App_core.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class ApiService {
  final String apiKey = "8cdee5526476b101869401a37c03e379";
  final String host = "aramizdakioyuncu.com";
  final String port = ""; // Port numarası
  final String ssl = "https";

  AppCore app = AppCore();

  Future<Map<String, dynamic>> request(
      String link, Map<String, String> formData) async {
    String requestUrl =
        "$ssl://$host:$port/botlar/$apiKey/${User.userName}/${User.password}/$link";
    log(requestUrl);
    formData['versiyon'] = app.getVersion().toString(); // Yeni öğeyi ekler
    formData['device'] = app.getDevice().toString(); // Yeni öğeyi ekler
    formData['devicemodel'] =
        app.getDeviceModel().toString(); // Yeni öğeyi ekler

    try {
      final response = await http.post(Uri.parse(requestUrl), body: formData);

      if (response.statusCode == 200) {
        // log(response.body);

        String responseContent = response.body;
        try {
          Map<String, dynamic> jsonData = json.decode(responseContent);
          return jsonData;
        } catch (e) {
          return {"durum": 0, "aciklama": "Json verisi gelmedi."};
        }
      } else {
        throw Exception(
            "İstek başarısız oldu. Durum kodu: ${response.statusCode}");
      }
    } catch (e) {
      return {"durum": 0, "aciklama": "Sunucuya bağlanılamadı."};
    }
  }
}
