import 'dart:developer';

import 'package:armoyu/app/core/api.dart';
import 'package:armoyu_widgets/data/models/ARMOYU/media.dart';
import 'package:armoyu_widgets/data/models/Survey/answer.dart';
import 'package:armoyu_widgets/data/models/Survey/question.dart';
import 'package:armoyu_widgets/data/models/Survey/survey.dart';
import 'package:armoyu_widgets/data/models/user.dart';
import 'package:armoyu_widgets/data/models/useraccounts.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/survey/survey_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart' as armoyumedia;
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollController extends GetxController {
  var surveyCounter = 1.obs;
  var surveyList = <Survey>[].obs;
  var firstfetching = true.obs;
  var controller = ScrollController().obs;
  var surveyListProcces = false.obs;
  var chatScrollController = ScrollController().obs;

  late var currentUserAccounts = Rxn<UserAccounts>();

  @override
  void onInit() {
    super.onInit();

    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //* *//
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    if (surveyList.isEmpty) {
      fetchsurveys();
    }

    controller.value.addListener(() {
      if (controller.value.position.pixels >=
          controller.value.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        fetchsurveys();
      }
    });
  }

  Future<void> fetchsurveys({bool restartfetch = false}) async {
    if (restartfetch) {
      surveyCounter.value = 1;

      surveyListProcces.value = false;
    }

    if (surveyListProcces.value) {
      return;
    }

    surveyListProcces.value = true;

    SurveyListResponse response = await API.service.surveyServices
        .fetchSurveys(page: surveyCounter.value);

    if (!response.result.status) {
      log(response.result.description);
      return;
    }
    if (restartfetch) {
      surveyList.value = <Survey>[].obs;
    }

    for (APISurveyList element in response.response!) {
      List<SurveyAnswer> surveyOptions = [];
      List<Media> surveyMedias = [];
      for (SurveyOption options in element.surveyOptions) {
        surveyOptions.add(
          SurveyAnswer(
            answerID: options.optionId,
            answerType: "answerType",
            value: options.optionAnswer,
            percentage: options.optionVotingPercentage,
          ),
        );
      }
      for (armoyumedia.Media media in element.surveyMedia) {
        surveyMedias.add(
          Media(
            mediaID: media.mediaID,
            mediaType: MediaType.image,
            mediaURL: MediaURL(
              bigURL: Rx<String>(media.mediaURL.bigURL),
              normalURL: Rx<String>(media.mediaURL.normalURL),
              minURL: Rx<String>(media.mediaURL.minURL),
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
              mediaID: element.surveyOwner.ownerId,
              mediaType: MediaType.image,
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

    surveyCounter.value++;
    firstfetching.value = false;
    surveyListProcces.value = false;
  }
}
