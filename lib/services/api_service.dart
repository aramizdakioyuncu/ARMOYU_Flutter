import 'dart:convert';
import 'dart:developer';
import 'package:ARMOYU/Core/App_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'User.dart';

class ApiService {
  final String apiKey = "8cdee5526476b101869401a37c03e379";
  final String host = "aramizdakioyuncu.com";
  final String port = ""; // Port numarası
  final String ssl = "https";

  AppCore app = AppCore();

  Future<Map<String, dynamic>> request(
      String link, Map<String, dynamic> formData,
      {List<MultipartFile>? files}) async {
    String requestUrl =
        "$ssl://$host:$port/botlar/$apiKey/${User.userName}/${User.password}/$link";
    log(requestUrl);

    formData['versiyon'] = app.getVersion().toString();
    formData['device'] = app.getDevice().toString();
    formData['devicemodel'] = app.getDeviceModel().toString();

    try {
      final request = http.MultipartRequest('POST', Uri.parse(requestUrl));

      // Dosya eklemek isterseniz, files listesini işleyin
      if (files != null) {
        for (var file in files) {
          request.files.add(file);
        }
      }

      // Diğer form verilerini ekleyin
      for (var key in formData.keys) {
        request.fields[key] = formData[key];
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        String responseContent = response.body;
        try {
          Map<String, dynamic> jsonData = json.decode(responseContent);
          log(jsonData["aciklama"].toString());
          return jsonData;
        } catch (e) {
          return {"durum": 0, "aciklama": "Json verisi gelmedi."};
        }
      } else {
        return {
          "durum": 0,
          "aciklama": "İstek başarısız oldu. Durum kodu: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"durum": 0, "aciklama": "Sunucuya bağlanılamadı."};
    }
  }
}
