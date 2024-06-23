import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Services/API/api_service.dart';

class FunctionsCategory {
  final User currentUser;
  late final ApiService apiService;

  FunctionsCategory({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }
  Future<Map<String, dynamic>> category(String categoryID) async {
    Map<String, String> formData = {"kategoriID": categoryID};
    Map<String, dynamic> jsonData =
        await apiService.request("kategoriler/0/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> categorydetail(String categoryID) async {
    Map<String, String> formData = {"kategoriID": categoryID};
    Map<String, dynamic> jsonData =
        await apiService.request("kategoriler-detay/0/0/", formData);
    return jsonData;
  }
}
