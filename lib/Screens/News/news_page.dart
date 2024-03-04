// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/news.dart';
import 'package:ARMOYU/Models/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({
    super.key,
    required this.news,
  });
  final News news;
  @override
  _EventStatePage createState() => _EventStatePage();
}

class _EventStatePage extends State<NewsPage> {
  @override
  void initState() {
    super.initState();

    fetchnewscontent(widget.news.newsID);
  }

  Future<void> fetchnewscontent(newsID) async {
    FunctionsNews f = FunctionsNews();
    Map<String, dynamic> response = await f.fetchnews(newsID);

    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    widget.news.newsContent = response["icerik"]["yaziicerik"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ARMOYU.bodyColor,
        appBar: AppBar(
          title: const Text('Etkinlikler'),
          backgroundColor: ARMOYU.appbarColor,
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
                  ? const CupertinoActivityIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.news.newsContent),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
