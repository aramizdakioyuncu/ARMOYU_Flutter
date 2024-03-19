import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/news.dart';
import 'package:ARMOYU/Models/news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewslistPage extends StatefulWidget {
  const NewslistPage({super.key});

  @override
  State<NewslistPage> createState() => _NewslistStatePage();
}

int newspage = 1;
bool eventlistProcces = false;
List<News> newsList = [];

final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

class _NewslistStatePage extends State<NewslistPage>
    with AutomaticKeepAliveClientMixin<NewslistPage> {
  final ScrollController scrollController = ScrollController();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    if (newsList.isEmpty) {
      getnewslist();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        getnewslist();
      }
    });
  }

  Future<void> getnewslist() async {
    if (eventlistProcces) {
      return;
    }

    eventlistProcces = true;
    FunctionsNews function = FunctionsNews();
    Map<String, dynamic> response = await function.fetch(newspage);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      eventlistProcces = false;
      //Tekrar çekmeyi dene
      getnewslist();
      return;
    }

    if (newspage == 1) {
      newsList.clear();
    }

    if (response['icerik'].length == 0) {
      eventlistProcces = true;
      log("Haner Sonu!");
      return;
    }
    for (dynamic element in response['icerik']) {
      if (mounted) {
        setState(() {
          newsList.add(
            News(
              newsID: element["haberID"],
              newsTitle: element["haberbaslik"],
              newsContent: "",
              author: element["yazar"],
              newsImage: element["resimminnak"],
              newssummary: element["ozet"],
              authoravatar: element["yazaravatar"],
              newsViews: element["goruntulen"],
            ),
          );
        });
      }
    }
    newspage++;
    eventlistProcces = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        appBar: AppBar(
          title: const Text('Haberler'),
          backgroundColor: ARMOYU.appbarColor,
        ),
        body: newsList.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: getnewslist,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    News aa = newsList[index];
                    return aa.newsListWidget(context);
                  },
                ),
              ),
      ),
    );
  }
}
