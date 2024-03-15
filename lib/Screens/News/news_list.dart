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

List<News> newsList = [];
bool eventlistProecces = false;
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();

class _NewslistStatePage extends State<NewslistPage>
    with AutomaticKeepAliveClientMixin<NewslistPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    if (newsList.isEmpty) {
      getnewslist();
    }
  }

  Future<void> getnewslist() async {
    if (eventlistProecces) {
      return;
    }
    eventlistProecces = true;
    FunctionsNews f = FunctionsNews();
    Map<String, dynamic> response = await f.fetch();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      eventlistProecces = false;
      //Tekrar çekmeyi dene
      getnewslist();
      return;
    }

    newsList.clear();
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
    eventlistProecces = false;
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
