import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsEvent {
  final User currentUser;
  late final ApiService apiService;

  FunctionsEvent({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> fetch() async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("etkinlikler/liste/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> detailfetch(int eventID) async {
    Map<String, String> formData = {"": ""};
    Map<String, dynamic> jsonData =
        await apiService.request("etkinlikler/$eventID/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> joinOrleave(int eventID, bool status) async {
    int intStatus = 0;
    if (status) {
      intStatus = 1;
    }
    Map<String, String> formData = {
      "etkinlikID": "$eventID",
      "cevap": "$intStatus"
    };

    Map<String, dynamic> jsonData =
        await apiService.request("etkinlikler/katilma/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> participantList(int eventID) async {
    Map<String, String> formData = {"etkinlikID": "$eventID"};
    Map<String, dynamic> jsonData =
        await apiService.request("etkinlikler/katilim/0/", formData);
    return jsonData;
  }
}
