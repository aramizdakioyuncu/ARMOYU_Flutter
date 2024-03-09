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

List<News> eventsList = [];
bool isfirstfetch = true;
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

    if (isfirstfetch) {
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

    eventsList.clear();
    for (dynamic element in response['icerik']) {
      if (mounted) {
        setState(() {
          eventsList.add(
            News(
              newsID: element["haberID"],
              newsTitle: element["haberbaslik"],
              newsContent: "",
              author: element["yazar"],
              newsImage: element["resimminnak"],
              newssummary: element["ozet"],
              authoravatar: element["yazaravatar"],
            ),
          );
        });
      }
    }
    isfirstfetch = false;
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
        body: eventsList.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: getnewslist,
                child: ListView.builder(
                  itemCount: eventsList.length,
                  itemBuilder: (context, index) {
                    News aa = eventsList[index];
                    return aa.newsListWidget(context);
                  },
                ),
              ),
      ),
    );
  }
}
