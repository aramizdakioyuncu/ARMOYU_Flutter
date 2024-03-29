import 'dart:convert';
import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/API.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  final String apiKey = API.apiKEY; // KEY
  final String host = API.apiHOST; // IP
  final String port = API.apiPORT; // Port numarası
  final String ssl = API.apiSSL; // https // https

  Future<Map<String, dynamic>> request(
      String link, Map<String, dynamic> formData,
      {List<MultipartFile>? files}) async {
    String requestUrl =
        "$ssl://$host:$port/botlar/$apiKey/${ARMOYU.Appuser.userName}/${ARMOYU.Appuser.password}/$link";
    log(requestUrl);

    formData['versiyon'] = ARMOYU.version;
    formData['device'] = ARMOYU.devicePlatform;
    formData['devicemodel'] = ARMOYU.deviceModel;

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
          return {
            "durum": 0,
            "aciklama": "Json verisi gelmedi.",
            "aciklamadetay": ""
          };
        }
      } else {
        return {
          "durum": 0,
          "aciklama":
              "İstek başarısız oldu. Durum kodu: ${response.statusCode}",
          "aciklamadetay": ""
        };
      }
    } catch (e) {
      log("Sunucuya bağlanılamadı.");
      return {
        "durum": 0,
        "aciklama": "Sunucuya bağlanılamadı.",
        "aciklamadetay": ""
      };
    }
  }
}
