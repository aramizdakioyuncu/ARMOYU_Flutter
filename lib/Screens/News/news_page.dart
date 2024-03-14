import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/news.dart';
import 'package:ARMOYU/Models/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({
    super.key,
    required this.news,
  });
  final News news;
  @override
  State<NewsPage> createState() => _EventStatePage();
}

bool isfirstfetch = true;
bool newsfetchProcess = false;

class _EventStatePage extends State<NewsPage>
    with AutomaticKeepAliveClientMixin<NewsPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    if (widget.news.newsContent == "") {
      fetchnewscontent(widget.news.newsID);
    }
  }

  Future<void> fetchnewscontent(newsID) async {
    if (newsfetchProcess) {
      return;
    }
    newsfetchProcess = true;
    FunctionsNews f = FunctionsNews();
    Map<String, dynamic> response = await f.fetchnews(newsID);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      newsfetchProcess = false;
      fetchnewscontent(widget.news.newsID);
      return;
    }

    Text(widget.news.newsContent);

    widget.news.newsContent = response["icerik"]["yaziicerik"].toString();
    var document = parse(widget.news.newsContent);
    widget.news.newsContent = document.outerHtml;
    newsfetchProcess = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        appBar: AppBar(
          title: Text(widget.news.newsTitle.toString()),
          backgroundColor: ARMOYU.appbarColor,
          actions: [
            IconButton(
              onPressed: () {
                fetchnewscontent(widget.news.newsID);
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                width: ARMOYU.screenWidth,
                height: ARMOYU.screenHeight / 5,
                imageUrl: widget.news.newsImage,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.news.newsTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              widget.news.newsContent == ""
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Html(
                        data: widget.news.newsContent,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
