import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Survey/answer.dart';
import 'package:ARMOYU/app/data/models/Survey/question.dart';
import 'package:ARMOYU/app/data/models/Survey/survey.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/survey.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PollDetailController extends GetxController {
  var chatScrollController = ScrollController().obs;
  var selectedOption = "".obs;

  var answerSurveyProccess = false.obs;

  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));
  late var survey = Rxn<Survey>();

  @override
  void onInit() {
    super.onInit();

    //***//
    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    //***//

    Map<String, dynamic> arguments = Get.arguments;

    survey.value = arguments['survey'];
    selectedOption.value = survey.value!.selectedOption.toString();

    log(survey.value!.didIVote.toString());
  }

  Future<void> answerfunction() async {
    if (answerSurveyProccess.value) {
      return;
    }

    answerSurveyProccess.value = true;
    FunctionsSurvey f = FunctionsSurvey(
      currentUser: currentUserAccounts.value.user.value,
    );
    Map<String, dynamic> response = await f.answerSurvey(
        survey.value!.surveyID, int.parse(selectedOption.value.toString()));

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      //Tekrar çekmeyi dene
      answerSurveyProccess.value = false;
      return;
    }
    await refreshSurvey();

    answerSurveyProccess.value = false;
  }

  Future<void> refreshSurvey() async {
    FunctionsSurvey f =
        FunctionsSurvey(currentUser: currentUserAccounts.value.user.value);

    Map<String, dynamic> response =
        await f.fetchSurvey(surveyID: survey.value!.surveyID);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    var surveyList = <Survey>[].obs;
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
              bigURL: Rx<String>(media["media_bigURL"]),
              normalURL: Rx<String>(media["media_URL"]),
              minURL: Rx<String>(media["media_minURL"]),
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
            displayName:
                Rx<String>(element["survey_owner"]["owner_displayname"]),
            avatar: Media(
              mediaID: element["survey_ID"],
              mediaURL: MediaURL(
                bigURL: Rx<String>(element["survey_owner"]["owner_avatar"]),
                normalURL: Rx<String>(element["survey_owner"]["owner_avatar"]),
                minURL: Rx<String>(element["survey_owner"]["owner_avatar"]),
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
    // surveyList;

    survey.value!.surveyOptions = surveyList[0].surveyOptions;
    survey.value!.surveyQuestion = surveyList[0].surveyQuestion;
    survey.value!.selectedOption = surveyList[0].selectedOption;
    survey.value!.didIVote = surveyList[0].didIVote;
  }

  Future<void> deleteSurvey() async {
    FunctionsSurvey f = FunctionsSurvey(
      currentUser: currentUserAccounts.value.user.value,
    );
    Map<String, dynamic> response =
        await f.deleteSurvey(survey.value!.surveyID);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    Get.back();
  }
}
