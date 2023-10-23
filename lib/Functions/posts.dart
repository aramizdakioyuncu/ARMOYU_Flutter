import '../Services/api_service.dart';

class FunctionsPosts {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> likeordislike(int postID) async {
    Map<String, String> formData = {"postID": "$postID", "kategori": "post"};
    Map<String, dynamic> jsonData =
        await _apiService.request("sosyal/begen/", formData);
    return jsonData;
  }
}
