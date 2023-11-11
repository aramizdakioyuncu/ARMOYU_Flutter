import '../Services/api_service.dart';

class FunctionsMedia {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> fetch(
      int uyeID, String category, int page) async {
    Map<String, String> formData = {
      "oyuncubakid": "$uyeID",
      "kategori": "$category",
      "sayfa": "$page"
    };
    Map<String, dynamic> jsonData =
        await apiService.request("medya/0/0/", formData);
    return jsonData;
  }
}
