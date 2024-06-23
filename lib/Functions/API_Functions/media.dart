import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Services/API/api_service.dart';
import 'package:http/http.dart';

class FunctionsMedia {
  final User currentUser;
  late final ApiService apiService;

  FunctionsMedia({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

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

  Future<Map<String, dynamic>> delete(int mediaID) async {
    Map<String, String> formData = {
      "medyaID": "$mediaID",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("medya/sil/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> upload({
    required List<Media> files,
    required String category,
  }) async {
    List<MultipartFile> photosCollection = [];
    for (Media file in files) {
      photosCollection.add(
        await AppCore.generateImageFile(
          "media[]",
          file.mediaXFile!,
        ),
      );
    }

    Map<String, String> formData;

    formData = {
      "category": category,
    };

    Map<String, dynamic> jsonData = await apiService
        .request("medya/yukle/", formData, files: photosCollection);
    return jsonData;
  }
}
