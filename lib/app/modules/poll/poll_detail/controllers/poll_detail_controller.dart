import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Survey/answer.dart';
import 'package:ARMOYU/app/data/models/Survey/question.dart';
import 'package:ARMOYU/app/data/models/Survey/survey.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/survey/survey_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/service_result.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart' as armoyumedia;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PollDetailController extends GetxController {
  var chatScrollController = ScrollController().obs;
  var selectedOption = "".obs;

  var answerSurveyProccess = false.obs;

  var currentUserAccounts =
      Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));
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

    ServiceResult response = await API.service.surveyServices.answerSurvey(
      surveyID: survey.value!.surveyID,
      optionID: int.parse(selectedOption.value.toString()),
    );

    if (!response.status) {
      log(response.description);
      //Tekrar çekmeyi dene
      answerSurveyProccess.value = false;
      return;
    }
    await refreshSurvey();

    answerSurveyProccess.value = false;
  }

  Future<void> refreshSurvey() async {
    SurveyListResponse response = await API.service.surveyServices
        .fetchSurvey(surveyID: survey.value!.surveyID);

    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    var surveyList = <Survey>[].obs;

    for (APISurveyList element in response.response!) {
      List<SurveyAnswer> surveyOptions = [];
      List<Media> surveyMedias = [];
      for (var options in element.surveyOptions) {
        surveyOptions.add(
          SurveyAnswer(
            answerID: options.optionId,
            answerType: "answerType",
            value: options.optionAnswer,
            percentage: options.optionVotingPercentage,
          ),
        );
      }
      for (armoyumedia.Media mediaelement in element.surveyMedia) {
        surveyMedias.add(
          Media(
            mediaID: mediaelement.mediaID,
            mediaURL: MediaURL(
              bigURL: Rx<String>(mediaelement.mediaURL.bigURL),
              normalURL: Rx<String>(mediaelement.mediaURL.normalURL),
              minURL: Rx<String>(mediaelement.mediaURL.minURL),
            ),
          ),
        );
      }
      surveyList.add(
        Survey(
          surveyID: element.surveyId,
          surveyQuestion: SurveyQuestion(
            questionValue: element.surveyQuestion,
            questionImages: surveyMedias,
          ),
          surveyOptions: surveyOptions,
          surveyOwner: User(
            userID: element.surveyOwner.ownerId,
            displayName: Rx<String>(element.surveyOwner.ownerDisplayName),
            avatar: Media(
              mediaID: element.surveyId,
              mediaURL: MediaURL(
                bigURL: Rx<String>(element.surveyOwner.ownerAvatar.bigURL),
                normalURL:
                    Rx<String>(element.surveyOwner.ownerAvatar.normalURL),
                minURL: Rx<String>(element.surveyOwner.ownerAvatar.minURL),
              ),
            ),
          ),
          surveyStatus: element.surveyStatus == 1 ? true : false,
          surveyvotingPercentage: element.surveyVotingPercentage,
          surveyvotingCount: element.surveyVotingCount,
          didIVote: element.surveyDidIVote == 1 ? true : false,
          selectedOption: element.surveySelectedOption,
          surveyEndDate: element.surveyEndDate,
          surveyRemainingTime: element.surveyRemainingTime,
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
    ServiceResult response = await API.service.surveyServices
        .deleteSurvey(surveyID: survey.value!.surveyID);

    if (!response.status) {
      log(response.description);
      return;
    }

    Get.back();
  }
}
