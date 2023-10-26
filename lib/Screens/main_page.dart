// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api, unused_field, unused_element

import 'dart:math';

import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Services/functions_service.dart';
import 'package:flutter/material.dart';

import '../Widgets/posts.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  @override
  bool get wantKeepAlive => true;

  int userID = -1;
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    userID = User.ID;
    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;

    // initState içinde sayfa yüklendiğinde yapılması gereken işlemleri gerçekleştirin
    loadPosts(postpage);

    // ScrollController'ı dinle
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });
  }

  Future<void> _handleRefresh() async {
    postpage = 1;

    setState(() {
      isRefreshing = true;
    });

    loadPosts(postpage);

    setState(() {
      isRefreshing = false;
    });
  }

  // Yeni veri yükleme işlemi
  void _loadMoreData() {
    postpage++;

    if (!postpageproccess) {
      postpageproccess = true;
      loadPosts(postpage);
    }
  }

  List<Widget> Widget_Posts = [];

  Future<void> loadPosts(int page) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getPosts(page);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
    }

    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;
    setState(() {
      if (page == 1) {
        Widget_Posts.clear();
      }
      for (int i = 0; i < dynamicItemCount; i++) {
        List<String> medias = [];

        if (response["icerik"][i]["paylasimfoto"].length != 0) {
          int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

          for (int j = 0; j < mediaItemCount; j++) {
            medias
                .add(response["icerik"][i]["paylasimfoto"][j]["fotominnakurl"]);
          }
        }

        Widget_Posts.add(
          TwitterPostWidget(
            userID: response["icerik"][i]["sahipID"],
            profileImageUrl: response["icerik"][i]["sahipavatarminnak"],
            username: response["icerik"][i]["sahipad"],
            postID: response["icerik"][i]["paylasimID"],
            postText: response["icerik"][i]["paylasimicerik"],
            postDate: response["icerik"][i]["paylasimzamangecen"],
            mediaUrls: medias,
            postlikeCount: response["icerik"][i]["begenisay"].toString(),
            postcommentCount: response["icerik"][i]["yorumsay"].toString(),
            postMecomment: response["icerik"][i]["benyorumladim"],
            postMelike: response["icerik"][i]["benbegendim"],
          ),
        );
      }
    });
    postpageproccess = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          controller: _scrollController,
          children: [
            Center(
              child: Column(
                children: Widget_Posts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
