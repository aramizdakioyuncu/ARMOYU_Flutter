import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/Client_Functions/survey.dart';
import 'package:ARMOYU/Models/Survey/survey.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Survey/surveynew_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SurveyListPage extends StatefulWidget {
  final User currentUser;
  const SurveyListPage({
    super.key,
    required this.currentUser,
  });

  @override
  State<SurveyListPage> createState() => _ChatPageState();
}

int _surveyCounter = 1;
List<Survey> _surveyList = [];
bool _firstfetching = true;

ScrollController _controller = ScrollController();

bool _surveyListProcces = false;

class _ChatPageState extends State<SurveyListPage>
    with AutomaticKeepAliveClientMixin<SurveyListPage> {
  final ScrollController chatScrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    if (_surveyList.isEmpty) {
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
    if (_surveyListProcces) {
      return;
    }

    _surveyListProcces = true;
    ClientFunctionSurvey function =
        ClientFunctionSurvey(currentUser: widget.currentUser);
    List<Survey>? response = await function.fetchsurvey(page: _surveyCounter);

    if (response == null) {
      _surveyListProcces = false;
      return;
    }
    if (_surveyCounter == 1) {
      _surveyList = response;
    } else {
      _surveyList += response;
    }
    _surveyCounter++;
    _firstfetching = false;
    setstatefonction();
    _surveyListProcces = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        title: const Text("Anketler"),
        backgroundColor: ARMOYU.appbarColor,
        actions: [
          IconButton(
            onPressed: () async {
              _surveyCounter = 1;
              _surveyListProcces = false;
              await fetchsurveys();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _firstfetching
          ? const Center(child: CupertinoActivityIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                controller: _controller,
                itemCount: _surveyList.length,
                itemBuilder: (context, index) {
                  return _surveyList[index]
                      .surveyList(context, currentUser: widget.currentUser);
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
              builder: (context) =>
                  SurveyNewPage(currentUser: widget.currentUser),
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
