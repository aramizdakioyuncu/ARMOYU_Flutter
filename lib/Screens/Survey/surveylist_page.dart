import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/survey.dart';
import 'package:ARMOYU/Models/Survey/answer.dart';
import 'package:ARMOYU/Models/Survey/question.dart';
import 'package:ARMOYU/Models/Survey/survey.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Survey/surveynew_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SurveyListPage extends StatefulWidget {
  const SurveyListPage({super.key});

  @override
  State<SurveyListPage> createState() => _ChatPageState();
}

int surveyCounter = 1;
List<Survey> surveyList = [];
bool firstfetching = true;

class _ChatPageState extends State<SurveyListPage>
    with AutomaticKeepAliveClientMixin<SurveyListPage> {
  final ScrollController chatScrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    if (surveyList.isEmpty) {
      fetchsurveys();
    }
  }

  Future<void> fetchsurveys() async {
    FunctionsSurvey function = FunctionsSurvey();
    Map<String, dynamic> response = await function.fetchSurveys(surveyCounter);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      //Tekrar çekmeyi dene
      fetchsurveys();
      return;
    }

    for (var element in response["icerik"]) {
      List<SurveyAnswer> surveyOptions = [];

      for (var options in element["survey_options"]) {
        surveyOptions.add(
          SurveyAnswer(
            answerID: options["option_ID"],
            answerType: "answerType",
            value: options["option_answer"],
          ),
        );
      }
      surveyList.add(
        Survey(
          surveyID: element["survey_ID"],
          surveyQuestion: SurveyQuestion(
            questionValue: element["survey_question"],
            questionImages: [
              Media(
                mediaID: element["survey_ID"],
                mediaURL: MediaURL(
                  bigURL:
                      "https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif",
                  normalURL:
                      "https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif",
                  minURL:
                      "https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif",
                ),
              ),
              Media(
                mediaID: element["survey_ID"],
                mediaURL: MediaURL(
                  bigURL:
                      "https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif",
                  normalURL:
                      "https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif",
                  minURL:
                      "https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif",
                ),
              ),
            ],
          ),
          surveyOptions: surveyOptions,
          surveyOwner: User(
            avatar: Media(
              mediaID: element["survey_ID"],
              mediaURL: MediaURL(
                bigURL: element["survey_owner"]["owner_avatar"],
                normalURL: element["survey_owner"]["owner_avatar"],
                minURL: element["survey_owner"]["owner_avatar"],
              ),
            ),
          ),
          surveyStatus: true,
          surveyvotingPercentage: element["survey_votingPercentage"],
          surveyvotingCount: element["survey_votingCount"],
        ),
      );
    }

    setState(() {
      firstfetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: AppBar(
        title: const Text("Anketler"),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: firstfetching
          ? const Center(child: CupertinoActivityIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: surveyList.length,
                itemBuilder: (context, index) {
                  return surveyList[index].surveyList(context);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: "NewChatButton",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SurveyNewPage(),
            ),
          );
        },
        backgroundColor: ARMOYU.buttonColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
