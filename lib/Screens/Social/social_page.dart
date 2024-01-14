// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_is_empty, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_this, prefer_final_fields, library_private_types_in_public_api, unused_field, unused_element, must_call_super, prefer_const_constructors_in_immutables

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Social/postshare_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/Skeletons/cards_skeleton.dart';
import 'package:ARMOYU/Widgets/Skeletons/storycircle_skeleton.dart';
import 'package:ARMOYU/Widgets/cards.dart';
import 'package:ARMOYU/Widgets/storycircle.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Widgets/Skeletons/posts_skeleton.dart';
import 'package:ARMOYU/Widgets/posts.dart';

class SocialPage extends StatefulWidget {
  final ScrollController homepageScrollController;

  SocialPage({required this.homepageScrollController});

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with AutomaticKeepAliveClientMixin<SocialPage> {
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController = widget.homepageScrollController;

  int userID = -1;
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;

  List<Widget> Widget_Posts = [];
  List<Map<String, String>> Widgettp_card = [];
  List<Map<String, String>> Widgetpop_card = [];

  List<Map<String, String>> Widget_storiescard = [];

  Widget? Widget_stories;

  Widget Widget_tpusers = SkeletonCustomCards(count: 5, icon: Icon(Icons.abc));
  Widget Widget_popusers = SkeletonCustomCards(count: 5, icon: Icon(Icons.abc));
  @override
  void initState() {
    super.initState();
    userID = User.ID;
    userName = User.displayName;
    userEmail = User.mail;
    useravatar = User.avatar;
    userbanner = User.banneravatar;

    loadSkeletonpost();
    // ScrollController'ı dinle
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });

    loadPosts(postpage);
  }

  Future<void> fetchstoryWidget(int page) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getplayerxp(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (page == 1) {
      Widget_storiescard.clear();
    }

    Widget_storiescard.add({
      "userID": User.ID.toString(),
      "image": User.avatarbetter,
      "displayname": User.displayName,
    });

    for (int i = 0; i < response["icerik"].length; i++) {
      if (response["icerik"][i]["oyuncuID"].toString() == User.ID.toString()) {
        continue;
      }
      Widget_storiescard.add({
        "userID": response["icerik"][i]["oyuncuID"].toString(),
        "image": response["icerik"][i]["oyuncuavatar"],
        "displayname": response["icerik"][i]["oyuncuadsoyad"],
      });
    }

    if (mounted) {
      setState(() {
        Widget_stories = Widget_Storycircle(content: Widget_storiescard);
      });
    }
  }

  Future<void> _handleRefresh() async {
    loadSkeletonpost();

    isRefreshing = true;
    loadPosts(1);
    isRefreshing = false;
  }

  // Yeni veri yükleme işlemi
  Future<void> _loadMoreData() async {
    postpage++;

    if (!postpageproccess) {
      postpageproccess = true;
      await loadPosts(postpage);
    }
  }

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
    if (page == 1) {
      Widget_Posts.clear();
    }

    int dynamicItemCount = response["icerik"].length;
    for (int i = 0; i < dynamicItemCount; i++) {
      List<int> mediaIDs = [];
      List<int> mediaownerIDs = [];
      List<String> medias = [];
      List<String> mediasbetter = [];
      List<String> mediastype = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

        for (int j = 0; j < mediaItemCount; j++) {
          mediaIDs.add(response["icerik"][i]["paylasimfoto"][j]["fotoID"]);
          mediaownerIDs.add(response["icerik"][i]["sahipID"]);
          medias.add(response["icerik"][i]["paylasimfoto"][j]["fotominnakurl"]);
          mediasbetter
              .add(response["icerik"][i]["paylasimfoto"][j]["fotoufakurl"]);
          mediastype.add(
              response["icerik"][i]["paylasimfoto"][j]["paylasimkategori"]);
        }
      }

      if (mounted) {
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
              mediatype: mediastype,
              postlikeCount: response["icerik"][i]["begenisay"],
              postcommentCount: response["icerik"][i]["yorumsay"],
              postMecomment: response["icerik"][i]["benyorumladim"],
              postMelike: response["icerik"][i]["benbegendim"],
              isPostdetail: false,
            ),
          );

          if (i / 3 == 1) {
            ScrollController scrollControllerPOP = ScrollController();

            Widget_popusers = CustomCards(
              scrollController: scrollControllerPOP,
              title: "POP",
              effectcolor: Color.fromARGB(255, 175, 10, 10).withOpacity(0.7),
              content: Widgetpop_card,
              icon: Icon(
                Icons.remove_red_eye_outlined,
                size: 15,
                color: Colors.white,
              ),
            );

            Widget_Posts.add(Widget_popusers);
          }
          if (i / 7 == 1) {
            ScrollController scrollControllerTP = ScrollController();

            Widget_tpusers = CustomCards(
              title: "TP",
              scrollController: scrollControllerTP,
              effectcolor: Color.fromARGB(255, 10, 84, 175).withOpacity(0.7),
              content: Widgettp_card,
              icon: Icon(
                Icons.auto_graph_outlined,
                size: 15,
                color: Colors.white,
              ),
            );
            Widget_Posts.add(Widget_tpusers);
          }
        });
      }
    }
  }

  Future<void> loadSkeletonpost() async {
    setState(() {
      Widget_stories = SkeletonStorycircle(count: 11);
      Widget_Posts.clear();

      Widget_Posts.add(SkeletonSocailPosts());
      Widget_Posts.add(SkeletonSocailPosts());
      Widget_Posts.add(SkeletonSocailPosts());
      Widget_Posts.add(SkeletonCustomCards(count: 5, icon: Icon(Icons.abc)));
      Widget_Posts.add(SkeletonSocailPosts());
      Widget_Posts.add(SkeletonSocailPosts());
      Widget_Posts.add(SkeletonSocailPosts());
      Widget_Posts.add(SkeletonSocailPosts());
    });
  }

  Future<void> fetchInternetdatas() async {
    fetchstoryWidget(1);
    loadXP_Cards(1);
    loadpop_Cards(1);
  }

  Future<void> loadPosts(int page) async {
    if (page == 1) {
      postpage = 1;

      await fetchInternetdatas();
    }

    await loadPostsv2(page);

    postpageproccess = false;
  }

  Future<void> loadXP_Cards(int page) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getplayerxp(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    if (page == 1) {
      Widgettp_card.clear();
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      Widgettp_card.add({
        "userID": response["icerik"][i]["oyuncuID"].toString(),
        "image": response["icerik"][i]["oyuncuavatar"],
        "displayname": response["icerik"][i]["oyuncuadsoyad"],
        "score": response["icerik"][i]["oyuncuseviyesezonlukxp"].toString()
      });
    }
  }

  Future<void> loadpop_Cards(int page) async {
    FunctionService f = FunctionService();
    Map<String, dynamic> response = await f.getplayerpop(1);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    if (page == 1) {
      Widgetpop_card.clear();
    }
    for (int i = 0; i < response["icerik"].length; i++) {
      Widgetpop_card.add({
        "userID": response["icerik"][i]["oyuncuID"].toString(),
        "image": response["icerik"][i]["oyuncuavatar"],
        "displayname": response["icerik"][i]["oyuncuadsoyad"],
        "score": response["icerik"][i]["oyuncupop"].toString()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: _handleRefresh,
        child: ListView(
          controller: _scrollController,
          children: [
            SizedBox(child: Widget_stories),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: Widget_Posts.length,
              itemBuilder: (context, index) {
                return Widget_Posts[index];
              },
            ),
          ],
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
        backgroundColor: ARMOYU.buttonColor,
        child: Icon(
          Icons.post_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
