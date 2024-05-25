import 'package:ARMOYU/Core/AppCore.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:http/http.dart';
import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsPosts {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> like(int postID) async {
    Map<String, String> formData = {
      "postID": "$postID",
      "kategori": "post",
    };
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begeni-ekle/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> unlike(int postID) async {
    Map<String, String> formData = {
      "postID": "$postID",
      "kategori": "post",
    };
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begeni-sil/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> commentlike(int commentID) async {
    Map<String, String> formData = {
      "postID": "$commentID",
      "kategori": "postyorum",
    };
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begeni-ekle/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> commentdislike(int commentID) async {
    Map<String, String> formData = {
      "postID": "$commentID",
      "kategori": "postyorum",
    };
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begeni-sil/", formData);
    return jsonData;
  }

//Share
  Future<Map<String, dynamic>> share(
    String text,
    List<Media> files, {
    String? location,
  }) async {
    List<MultipartFile> photosCollection = [];
    for (Media file in files) {
      photosCollection.add(
        await AppCore.generateImageFile(
          "paylasimfoto[]",
          file.mediaXFile!,
        ),
      );
    }

    Map<String, String> formData;

    if (location != null) {
      formData = {
        "sosyalicerik": text,
        "konum": location,
      };
    } else {
      formData = {
        "sosyalicerik": text,
      };
    }

    Map<String, dynamic> jsonData = await _apiService
        .request("sosyal/olustur/", formData, files: photosCollection);
    return jsonData;
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

  Future<Map<String, dynamic>> getPosts(int page) async {
    Map<String, String> formData = {"limit": "20"};
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/liste/$page/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> detailfetch({
    int? postID,
    String? category,
    int? categoryDetail,
  }) async {
    Map<String, String> formData = {
      "postID": "$postID",
      "category": "$category",
      "categorydetail": "$categoryDetail",
    };
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
      "yorumicerik": text,
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
