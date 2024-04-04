import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Survey/survey.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/buttons.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  final Survey survey;
  const SurveyPage({
    super.key,
    required this.survey,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: AppBar(
        title: const Text("Anket Sorusu"),
        backgroundColor: ARMOYU.appbarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
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
                            media: widget.survey.surveyQuestion.questionImages!,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      width: ARMOYU.screenWidth,
                      height: ARMOYU.screenHeight / 3,
                      imageUrl:
                          "https://github.com/imaNNeo/fl_chart/raw/main/repo_files/images/bar_chart/bar_chart_sample_1.gif",
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            WidgetUtility.specialText(
              context,
              widget.survey.surveyQuestion.questionValue,
            ),
            Column(
              children:
                  List.generate(widget.survey.surveyOptions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RadioListTile<String>(
                    title: Text(widget.survey.surveyOptions[index].value),
                    value:
                        widget.survey.surveyOptions[index].answerID.toString(),
                    activeColor: Colors.red,
                    tileColor: ARMOYU.textbackColor,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtons.costum1(
                "OYLA",
                onPressed: () {},
                loadingStatus: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
