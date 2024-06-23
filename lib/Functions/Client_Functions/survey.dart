import 'dart:developer';
import 'package:ARMOYU/Functions/API_Functions/survey.dart';
import 'package:ARMOYU/Models/Survey/answer.dart';
import 'package:ARMOYU/Models/Survey/question.dart';
import 'package:ARMOYU/Models/Survey/survey.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Services/API/api_service.dart';

class ClientFunctionSurvey {
  final User currentUser;
  late final ApiService apiService;

  ClientFunctionSurvey({required this.currentUser}) {
    apiService = ApiService(user: currentUser);
  }

  Future<List<Survey>?> fetchsurvey({int? page, int? surveyID}) async {
    FunctionsSurvey f = FunctionsSurvey(currentUser: currentUser);

    Map<String, dynamic>? response;
    if (surveyID != null) {
      response = await f.fetchSurvey(surveyID: surveyID);
    } else {
      page ??= 1;
      response = await f.fetchSurveys(page: page);
    }

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return null;
    }

    List<Survey> surveyList = [];
    for (var element in response["icerik"]) {
      List<SurveyAnswer> surveyOptions = [];
      List<Media> surveyMedias = [];
      for (var options in element["survey_options"]) {
        surveyOptions.add(
          SurveyAnswer(
            answerID: options["option_ID"],
            answerType: "answerType",
            value: options["option_answer"],
            percentage: double.parse(options["option_votingPercentage"]),
          ),
        );
      }
      for (var media in element["survey_media"]) {
        surveyMedias.add(
          Media(
            mediaID: media["media_ID"],
            mediaURL: MediaURL(
              bigURL: media["media_bigURL"],
              normalURL: media["media_URL"],
              minURL: media["media_minURL"],
            ),
          ),
        );
      }
      surveyList.add(
        Survey(
          surveyID: element["survey_ID"],
          surveyQuestion: SurveyQuestion(
            questionValue: element["survey_question"],
            questionImages: surveyMedias,
          ),
          surveyOptions: surveyOptions,
          surveyOwner: User(
            userID: element["survey_owner"]["owner_ID"],
            displayName: element["survey_owner"]["owner_displayname"],
            avatar: Media(
              mediaID: element["survey_ID"],
              mediaURL: MediaURL(
                bigURL: element["survey_owner"]["owner_avatar"],
                normalURL: element["survey_owner"]["owner_avatar"],
                minURL: element["survey_owner"]["owner_avatar"],
              ),
            ),
          ),
          surveyStatus: element["survey_status"] == 1 ? true : false,
          surveyvotingPercentage: element["survey_votingPercentage"],
          surveyvotingCount: element["survey_votingCount"],
          didIVote: element["survey_didIVote"] == 1 ? true : false,
          selectedOption: element["survey_selectedOption"],
          surveyEndDate: element["survey_enddate"],
          surveyRemainingTime: element["survey_remainingtime"],
        ),
      );
    }
    return surveyList;
  }
}
