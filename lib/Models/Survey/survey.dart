import 'package:ARMOYU/Models/Survey/answer.dart';
import 'package:ARMOYU/Models/Survey/question.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Survey/survey_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Survey {
  final int surveyID;
  SurveyQuestion surveyQuestion;
  List<SurveyAnswer> surveyOptions;
  User surveyOwner;
  bool surveyStatus;
  int surveyvotingPercentage;
  int surveyvotingCount;
  bool didIVote;
  int selectedOption;
  String surveyEndDate;
  String surveyRemainingTime;

  Survey({
    required this.surveyID,
    required this.surveyQuestion,
    required this.surveyOptions,
    required this.surveyOwner,
    required this.surveyStatus,
    required this.surveyvotingPercentage,
    required this.surveyvotingCount,
    required this.didIVote,
    required this.selectedOption,
    required this.surveyEndDate,
    required this.surveyRemainingTime,
  });

  Widget surveyList(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyPage(
              survey: this,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    surveyQuestion.questionValue,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.amber),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(
                    surveyOptions.length,
                    (index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    surveyOptions[index].value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 65,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${surveyOptions[index].percentage * 100 == 100 ? "100" : surveyOptions[index].percentage * 100 == 0 ? "0" : (surveyOptions[index].percentage * 100).toStringAsFixed(2)}%"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(
                              begin: 0,
                              end: surveyOptions[index].percentage,
                            ),
                            builder: (context, value, _) =>
                                LinearProgressIndicator(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              semanticsLabel: "Oylama Oranı",
                              semanticsValue: "%10",
                              minHeight: 14,
                              color: surveyOptions[index].percentage >= 0.5
                                  ? Colors.amber
                                  : Colors.red,
                              value: value,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              surveyEndDate,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.hourglass_bottom_outlined,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              surveyRemainingTime == ""
                                  ? "Süresi Bitti"
                                  : surveyRemainingTime,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: surveyRemainingTime == ""
                                    ? Colors.red
                                    : Colors.greenAccent,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              surveyvotingCount.toString(),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.stacked_bar_chart,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              didIVote ? 'Oylandı' : 'Oylanmadı',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: didIVote ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: CachedNetworkImageProvider(
                            surveyOwner.avatar!.mediaURL.minURL,
                          ),
                        ),
                        Text(
                          surveyOwner.displayName.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
