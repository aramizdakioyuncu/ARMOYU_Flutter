import 'package:ARMOYU/Models/Survey/answer.dart';
import 'package:ARMOYU/Models/Survey/question.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Survey/survey_page.dart';
import 'package:flutter/material.dart';

class Survey {
  final int surveyID;
  final SurveyQuestion surveyQuestion;
  final List<SurveyAnswer> surveyOptions;
  final User surveyOwner;
  final bool surveyStatus;
  final int surveyvotingPercentage;
  final int surveyvotingCount;

  Survey({
    required this.surveyID,
    required this.surveyQuestion,
    required this.surveyOptions,
    required this.surveyOwner,
    required this.surveyStatus,
    required this.surveyvotingPercentage,
    required this.surveyvotingCount,
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
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anket ID: $surveyID',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Soru: ${surveyQuestion.questionValue}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Durumu: ${surveyStatus ? 'Aktif' : 'Pasif'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.people),
                const SizedBox(width: 5),
                Text(
                  surveyvotingCount.toString(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text("$surveyvotingPercentage%"),
                const SizedBox(width: 10),
                CircularProgressIndicator(
                  strokeWidth: 5,
                  value: surveyvotingPercentage / 100,
                  color: Colors.red,
                  backgroundColor: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
