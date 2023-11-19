// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../Functions/posts.dart';
import '../../Widgets/posts.dart';

class PostDetailPage extends StatefulWidget {
  final int postID;

  PostDetailPage({required this.postID});

  @override
  _PostDetailPage createState() => _PostDetailPage();
}

class _PostDetailPage extends State<PostDetailPage>
    with AutomaticKeepAliveClientMixin<PostDetailPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    postdetailfetch();
  }

  Widget asa = Text("");
  Future<void> postdetailfetch() async {
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.detailfetch(widget.postID);
    if (response["durum"] == 0) {
      print(response["aciklama"]);
      return;
    }

    List<int> mediaIDs = [];
    List<int> mediaownerIDs = [];
    List<String> medias = [];
    List<String> mediasbetter = [];
    List<String> mediastype = [];

    if (response["icerik"][0]["paylasimfoto"].length != 0) {
      int mediaItemCount = response["icerik"][0]["paylasimfoto"].length;

      for (int j = 0; j < mediaItemCount; j++) {
        mediaIDs.add(response["icerik"][0]["paylasimfoto"][j]["fotoID"]);
        mediaownerIDs.add(response["icerik"][0]["sahipID"]);
        medias.add(response["icerik"][0]["paylasimfoto"][j]["fotominnakurl"]);
        mediasbetter
            .add(response["icerik"][0]["paylasimfoto"][j]["fotoufakurl"]);
        mediastype
            .add(response["icerik"][0]["paylasimfoto"][j]["paylasimkategori"]);
      }
    }

    asa = TwitterPostWidget(
      userID: response["icerik"][0]["sahipID"],
      profileImageUrl: response["icerik"][0]["sahipavatarminnak"],
      username: response["icerik"][0]["sahipad"],
      postID: response["icerik"][0]["paylasimID"],
      postText: response["icerik"][0]["paylasimicerik"],
      postDate: response["icerik"][0]["paylasimzamangecen"],
      mediaIDs: mediaIDs,
      mediaownerIDs: mediaownerIDs,
      mediaUrls: medias,
      mediabetterUrls: mediasbetter,
      mediatype: mediastype,
      postlikeCount: response["icerik"][0]["begenisay"],
      postcommentCount: response["icerik"][0]["yorumsay"],
      postMecomment: response["icerik"][0]["benyorumladim"],
      postMelike: response["icerik"][0]["benbegendim"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paylaşım', style: TextStyle(fontSize: 18)),
        toolbarHeight: 40,
      ),
      body: asa,
    );
  }
}
