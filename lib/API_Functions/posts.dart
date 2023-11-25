import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../Services/api_service.dart';

class FunctionsPosts {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> likeordislike(int postID) async {
    Map<String, String> formData = {"postID": "$postID", "kategori": "post"};
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begen/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> commentlikeordislike(int commentID) async {
    Map<String, String> formData = {
      "postID": "$commentID",
      "kategori": "postyorum"
    };
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begen/", formData);
    return jsonData;
  }

//Share
  Future<Map<String, dynamic>> share(String text, List<XFile> files) async {
    List<MultipartFile> photosCollection = [];
    for (var file in files) {
      photosCollection.add(await generateImageFile(file));
    }

    Map<String, String> formData = {
      "sosyalicerik": text,
    };

    Map<String, dynamic> jsonData = await _apiService
        .request("sosyal/olustur/", formData, files: photosCollection);
    return jsonData;
  }

  Future<MultipartFile> generateImageFile(XFile file) async {
    final fileBytes = await file.readAsBytes();
    return MultipartFile.fromBytes('paylasimfoto[]', fileBytes,
        filename: file.name);
  }

  //*Share

  //Post Remove
  Future<Map<String, dynamic>> remove(int postID) async {
    Map<String, String> formData = {"postID": "$postID"};
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/sil/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> removecomment(int commentID) async {
    Map<String, String> formData = {"yorumID": "$commentID"};
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/yorum-sil/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> detailfetch(int postID) async {
    Map<String, String> formData = {"postID": "$postID"};
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/liste/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> commentsfetch(int postID) async {
    Map<String, String> formData = {"postID": "$postID"};
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/yorumlar/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> createcomment(int postID, String text) async {
    Map<String, String> formData = {
      "postID": "$postID",
      "yorumicerik": "$text",
      "kategori": "sosyal"
    };
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/yorum-olustur/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> postlikeslist(int postID) async {
    Map<String, String> formData = {
      "postID": "$postID",
    };
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begenenler/", formData);
    return jsonData;
  }
}
