import 'dart:developer';

import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Survey/answer.dart';
import 'package:ARMOYU/app/data/models/Survey/question.dart';
import 'package:ARMOYU/app/data/models/Survey/survey.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/survey.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
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

    FunctionsSurvey f =
        FunctionsSurvey(currentUser: currentUserAccounts.value!.user.value);

    Map<String, dynamic> response =
        await f.fetchSurveys(page: surveyCounter.value);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    if (restartfetch) {
      surveyList.value = <Survey>[].obs;
    }
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

    surveyCounter.value++;
    firstfetching.value = false;
    surveyListProcces.value = false;
  }
}
