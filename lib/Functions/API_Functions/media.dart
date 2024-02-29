import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Services/API/api_service.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class FunctionsMedia {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> fetch(
      int uyeID, String category, int page) async {
    Map<String, String> formData = {
      "oyuncubakid": "$uyeID",
      "kategori": category,
      "limit": "30",
      "sayfa": "$page"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("medya/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> rotation(int mediaID, double rotate) async {
    Map<String, String> formData = {
      "fotografID": "$mediaID",
      "derece": "$rotate"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("medya/donder/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> share(String text, List<XFile> files) async {
    List<MultipartFile> photosCollection = [];
    for (var file in files) {
      photosCollection
          .add(await AppCore.generateImageFile("paylasimfoto[]", file));
    }

    Map<String, String> formData = {
      "sosyalicerik": text,
    };

    Map<String, dynamic> jsonData = await apiService
        .request("sosyal/olustur/", formData, files: photosCollection);
    return jsonData;
  }
}
