import 'dart:developer';

import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/Services/API/api_service.dart';

class FunctionsSurvey {
  final User currentUser;
  late final ApiService apiService;

  FunctionsSurvey({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<Map<String, dynamic>> fetchSurveys({required int page}) async {
    Map<String, String> formData = {"sayfa": "$page"};
    Map<String, dynamic> jsonData =
        await apiService.request("anketler/liste/0/", formData);

    return jsonData;
  }

  Future<Map<String, dynamic>> fetchSurvey({required int surveyID}) async {
    Map<String, String> formData = {"anketID": "$surveyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("anketler/liste/0/", formData);

    return jsonData;
  }

  Future<Map<String, dynamic>> answerSurvey(int surveyID, int optionID) async {
    Map<String, String> formData = {
      "anketID": "$surveyID",
      "secenekID": "$optionID",
    };
    Map<String, dynamic> jsonData =
        await apiService.request("anketler/yanitla/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> deleteSurvey(int surveyID) async {
    Map<String, String> formData = {"anketID": "$surveyID"};
    Map<String, dynamic> jsonData =
        await apiService.request("anketler/sil/0/", formData);
    return jsonData;
  }

  Future<Map<String, dynamic>> createSurvey(
      String surveyQuestion, List<String> options, String date) async {
    Map<String, String> formData = {
      "anketsoru": surveyQuestion,
      "bitiszaman": date,
      "kime": "0",
    };

    for (int i = 0; i < options.length; i++) {
      formData['secenekler[$i]'] = options[i];
    }
    log(formData.toString());

    Map<String, dynamic> jsonData =
        await apiService.request("anketler/olustur/0/", formData);
    return jsonData;
  }
}
