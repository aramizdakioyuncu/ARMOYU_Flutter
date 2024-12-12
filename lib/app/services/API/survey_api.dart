import 'package:ARMOYU/app/Core/API.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';

class SurveyAPI {
  final User currentUser;
  SurveyAPI({required this.currentUser});

  Future<SurveyListResponse> fetchSurveys({required int page}) async {
    return await API.service.surveyServices.fetchSurveys(page: page);
  }

  Future<SurveyListResponse> fetchSurvey({required int surveyID}) async {
    return await API.service.surveyServices.fetchSurvey(surveyID: surveyID);
  }

  Future<ServiceResult> answerSurvey({
    required int surveyID,
    required int optionID,
  }) async {
    return await API.service.surveyServices.answerSurvey(
      surveyID: surveyID,
      optionID: optionID,
    );
  }

  Future<ServiceResult> deleteSurvey({required int surveyID}) async {
    return await API.service.surveyServices.deleteSurvey(surveyID: surveyID);
  }

  Future<ServiceResult> createSurvey({
    required String surveyQuestion,
    required List<String> options,
    required String date,
  }) async {
    return await API.service.surveyServices.createSurvey(
      surveyQuestion: surveyQuestion,
      options: options,
      date: date,
    );
  }
}
