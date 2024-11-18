import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class SurveyAPI {
  final User currentUser;
  SurveyAPI({required this.currentUser});

  Future<Map<String, dynamic>> fetchSurveys({
    required int page,
  }) async {
    return await API.service.surveyServices.fetchSurveys(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      page: page,
    );
  }

  Future<Map<String, dynamic>> fetchSurvey({
    required int surveyID,
  }) async {
    return await API.service.surveyServices.fetchSurvey(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      surveyID: surveyID,
    );
  }

  Future<Map<String, dynamic>> answerSurvey({
    required int surveyID,
    required int optionID,
  }) async {
    return await API.service.surveyServices.answerSurvey(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      surveyID: surveyID,
      optionID: optionID,
    );
  }

  Future<Map<String, dynamic>> deleteSurvey({
    required int surveyID,
  }) async {
    return await API.service.surveyServices.deleteSurvey(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      surveyID: surveyID,
    );
  }

  Future<Map<String, dynamic>> createSurvey({
    required String surveyQuestion,
    required List<String> options,
    required String date,
  }) async {
    return await API.service.surveyServices.createSurvey(
      username: currentUser.userName!.value,
      password: currentUser.password!.value,
      surveyQuestion: surveyQuestion,
      options: options,
      date: date,
    );
  }
}
