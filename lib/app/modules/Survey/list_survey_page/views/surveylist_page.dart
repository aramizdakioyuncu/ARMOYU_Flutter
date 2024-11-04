import 'package:ARMOYU/app/functions/Client_Functions/survey.dart';
import 'package:ARMOYU/app/data/models/Survey/survey.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/Survey/new_survey_page/views/surveynew_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SurveyListPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  const SurveyListPage({
    super.key,
    required this.currentUserAccounts,
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
    ClientFunctionSurvey function = ClientFunctionSurvey(
      currentUser: widget.currentUserAccounts.user,
    );
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
      appBar: AppBar(
        title: const Text("Anketler"),
        // backgroundColor: ARMOYU.appbarColor,
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
                  return _surveyList[index].surveyList(
                    context,
                    currentUserAccounts: widget.currentUserAccounts,
                  );
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
              builder: (context) => SurveyNewPage(
                currentUserAccounts: widget.currentUserAccounts,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
