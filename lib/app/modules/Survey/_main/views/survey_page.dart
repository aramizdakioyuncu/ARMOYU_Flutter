import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/survey.dart';
import 'package:ARMOYU/app/functions/Client_Functions/survey.dart';
import 'package:ARMOYU/app/data/models/Survey/survey.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/Utility/newphotoviewer.dart';
import 'package:ARMOYU/app/widgets/buttons.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  final Survey survey;
  final UserAccounts currentUserAccounts;
  const SurveyPage({
    super.key,
    required this.survey,
    required this.currentUserAccounts,
  });

  @override
  State<SurveyPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<SurveyPage>
    with AutomaticKeepAliveClientMixin<SurveyPage> {
  final ScrollController chatScrollController = ScrollController();
  String? _selectedOption;
  @override
  bool get wantKeepAlive => true;
  bool answerSurveyProccess = false;

  Future<void> answerfunction() async {
    if (answerSurveyProccess) {
      return;
    }

    answerSurveyProccess = true;
    FunctionsSurvey f = FunctionsSurvey(
      currentUser: widget.currentUserAccounts.user,
    );
    Map<String, dynamic> response = await f.answerSurvey(
        widget.survey.surveyID, int.parse(_selectedOption.toString()));

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      //Tekrar çekmeyi dene
      answerSurveyProccess = false;
      return;
    }
    await refreshSurvey();

    answerSurveyProccess = false;
  }

  Future<void> refreshSurvey() async {
    ClientFunctionSurvey f = ClientFunctionSurvey(
      currentUser: widget.currentUserAccounts.user,
    );
    List<Survey>? response =
        await f.fetchsurvey(surveyID: widget.survey.surveyID);

    if (response == null) {
      return;
    }

    widget.survey.surveyOptions = response[0].surveyOptions;
    widget.survey.surveyQuestion = response[0].surveyQuestion;
    widget.survey.selectedOption = response[0].selectedOption;
    widget.survey.didIVote = response[0].didIVote;
  }

  Future<void> deleteSurvey() async {
    FunctionsSurvey f = FunctionsSurvey(
      currentUser: widget.currentUserAccounts.user,
    );
    Map<String, dynamic> response =
        await f.deleteSurvey(widget.survey.surveyID);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.survey.selectedOption.toString();

    log(widget.survey.didIVote.toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        title: const Text("Anket Sorusu"),
        backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
            onPressed: () async => await refreshSurvey(),
            icon: const Icon(Icons.refresh),
          ),
          Visibility(
            visible: widget.survey.surveyOwner.userID ==
                widget.currentUserAccounts.user.userID,
            child: IconButton(
              onPressed: () async => await deleteSurvey(),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ARMOYU.appbarColor,
              height: ARMOYU.screenHeight / 3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.survey.surveyQuestion.questionImages!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaViewer(
                            currentUser: widget.currentUserAccounts.user,
                            media: widget.survey.surveyQuestion.questionImages!,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      width: ARMOYU.screenWidth,
                      height: ARMOYU.screenHeight / 3,
                      imageUrl: widget.survey.surveyQuestion
                          .questionImages![index].mediaURL.normalURL,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: WidgetUtility.specialText(
                            context,
                            currentUserAccounts: widget.currentUserAccounts,
                            widget.survey.surveyQuestion.questionValue,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: CachedNetworkImageProvider(
                                widget
                                    .survey.surveyOwner.avatar!.mediaURL.minURL,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // Yatay kaydırma için
                              child: Text(
                                widget.survey.surveyOwner.displayName
                                    .toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //Result
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                            widget.survey.surveyOptions.length, (index) {
                          return RadioListTile<String>(
                            contentPadding: const EdgeInsets.all(0),
                            title: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.survey.surveyOptions[index].value,
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
                                  end: widget
                                      .survey.surveyOptions[index].percentage,
                                ),
                                builder: (context, value, _) => Stack(
                                  children: [
                                    LinearProgressIndicator(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      semanticsLabel: "Oylama Oranı",
                                      semanticsValue: "%10",
                                      minHeight: 20,
                                      color: widget.survey.surveyOptions[index]
                                                  .percentage >=
                                              0.5
                                          ? Colors.amber
                                          : Colors.red,
                                      value: value,
                                    ),
                                    Center(
                                      child: SizedBox(
                                        width: 65,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${widget.survey.surveyOptions[index].percentage * 100 == 100 ? "100" : widget.survey.surveyOptions[index].percentage * 100 == 0 ? "0" : (widget.survey.surveyOptions[index].percentage * 100).toStringAsFixed(2)}%",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            value: widget.survey.surveyOptions[index].answerID
                                .toString(),
                            activeColor: Colors.amber,
                            groupValue: _selectedOption,
                            onChanged: widget.survey.didIVote ||
                                    answerSurveyProccess ||
                                    !widget.survey.surveyStatus
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedOption = value;
                                    });
                                  },
                          );
                        }),
                      ),
                      Visibility(
                        visible: !widget.survey.didIVote &&
                            widget.survey.surveyStatus,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButtons.costum1(
                            text: "OYLA",
                            onPressed: () async => await answerfunction(),
                            loadingStatus: answerSurveyProccess,
                          ),
                        ),
                      ),
                    ],
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
