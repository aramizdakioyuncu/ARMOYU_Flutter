// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api, unused_field, unused_element, must_call_super

import 'dart:math';

import 'package:ARMOYU/Screens/Social/postshare_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Services/functions_service.dart';
import 'package:ARMOYU/Widgets/cards.dart';
import 'package:flutter/material.dart';
import '../../Widgets/posts.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with AutomaticKeepAliveClientMixin<SocialPage> {
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

    await loadPosts(postpage);

    setState(() {
      isRefreshing = false;
    });
  }

  // Yeni veri yükleme işlemi
  Future<void> _loadMoreData() async {
    postpage++;

    if (!postpageproccess) {
      postpageproccess = true;
      await loadPosts(postpage);
    }
  }

  List<Widget> Widget_Posts = [];
  Widget? Widget_tpusers;
  Widget? Widget_popusers;

  Future<void> loadPostsv2(int page) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getPosts(page);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
      return;
    }
    int dynamicItemCount = response["icerik"].length;

    for (int i = 0; i < dynamicItemCount; i++) {
      List<int> mediaIDs = [];
      List<int> mediaownerIDs = [];
      List<String> medias = [];
      List<String> mediasbetter = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

        for (int j = 0; j < mediaItemCount; j++) {
          mediaIDs.add(response["icerik"][i]["paylasimfoto"][j]["fotoID"]);
          mediaownerIDs.add(response["icerik"][i]["sahipID"]);
          medias.add(response["icerik"][i]["paylasimfoto"][j]["fotominnakurl"]);
          mediasbetter
              .add(response["icerik"][i]["paylasimfoto"][j]["fotoufakurl"]);
        }
      }
      setState(() {
        Widget_Posts.add(
          TwitterPostWidget(
            userID: response["icerik"][i]["sahipID"],
            profileImageUrl: response["icerik"][i]["sahipavatarminnak"],
            username: response["icerik"][i]["sahipad"],
            postID: response["icerik"][i]["paylasimID"],
            postText: response["icerik"][i]["paylasimicerik"],
            postDate: response["icerik"][i]["paylasimzamangecen"],
            mediaIDs: mediaIDs,
            mediaownerIDs: mediaownerIDs,
            mediaUrls: medias,
            mediabetterUrls: mediasbetter,
            postlikeCount: response["icerik"][i]["begenisay"],
            postcommentCount: response["icerik"][i]["yorumsay"],
            postMecomment: response["icerik"][i]["benyorumladim"],
            postMelike: response["icerik"][i]["benbegendim"],
          ),
        );

        if (i / 3 == 1) {
          Widget_Posts.add(Widget_popusers!);
        }
        if (i / 7 == 1) {
          Widget_Posts.add(Widget_tpusers!);
        }
      });
    }
  }

  Future<void> loadPosts(int page) async {
    if (page == 1) {
      Widget_Posts.clear();
      await loadXP_Cards(1);
      await loadpop_Cards(1);
    }
    await loadPostsv2(page);

    postpageproccess = false;
  }

  Future<void> loadXP_Cards(int page) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getplayerxp();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    List<Map<String, String>> Widget_card = [];
    for (int i = 0; i < response["icerik"].length; i++) {
      Widget_card.add({
        "userID": response["icerik"][i]["oyuncuID"].toString(),
        "image": response["icerik"][i]["oyuncuavatar"],
        "displayname": response["icerik"][i]["oyuncuadsoyad"],
        "score": response["icerik"][i]["oyuncuseviyesezonlukxp"].toString()
      });
    }

    Widget_tpusers = CustomCards(
      content: Widget_card,
      icon: Icon(
        Icons.auto_graph_outlined,
        size: 15,
        color: Colors.white,
      ),
    );
  }

  Future<void> loadpop_Cards(int page) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getplayerpop();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    List<Map<String, String>> Widgetpop_card = [];
    for (int i = 0; i < response["icerik"].length; i++) {
      Widgetpop_card.add({
        "userID": response["icerik"][i]["oyuncuID"].toString(),
        "image": response["icerik"][i]["oyuncuavatar"],
        "displayname": response["icerik"][i]["oyuncuadsoyad"],
        "score": response["icerik"][i]["oyuncupop"].toString()
      });
    }

    Widget_popusers = CustomCards(
      content: Widgetpop_card,
      icon: Icon(
        Icons.remove_red_eye_outlined,
        size: 15,
        color: Colors.white,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: _handleRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: Widget_Posts.length,
          itemBuilder: (context, index) {
            return Widget_Posts[index];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PostSharePage(
              appbar: true,
            ),
          ));
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.post_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
