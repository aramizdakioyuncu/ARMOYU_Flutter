import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/Client_Functions/survey.dart';
import 'package:ARMOYU/Models/Survey/survey.dart';
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

ScrollController _controller = ScrollController();

bool surveyListProcces = false;

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

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        fetchsurveys();
      }
    });
  }

  void setstatefonction() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchsurveys() async {
    if (surveyListProcces) {
      return;
    }

    surveyListProcces = true;
    ClientFunctionSurvey function = ClientFunctionSurvey();
    List<Survey>? response = await function.fetchsurvey(page: surveyCounter);

    if (response == null) {
      surveyListProcces = false;
      return;
    }
    if (surveyCounter == 1) {
      surveyList = response;
    } else {
      surveyList += response;
    }
    surveyCounter++;
    firstfetching = false;
    setstatefonction();
    surveyListProcces = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      appBar: AppBar(
        title: const Text("Anketler"),
        backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
            onPressed: () async {
              surveyCounter = 1;
              surveyListProcces = false;
              await fetchsurveys();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: firstfetching
          ? const Center(child: CupertinoActivityIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                controller: _controller,
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
