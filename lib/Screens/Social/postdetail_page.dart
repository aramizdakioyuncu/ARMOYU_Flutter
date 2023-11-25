// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, must_call_super, prefer_const_constructors, non_constant_identifier_names

import 'package:ARMOYU/Core/screen.dart';
import 'package:ARMOYU/Widgets/post-comments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../API_Functions/posts.dart';
import '../../Services/User.dart';
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
    getcommentsfetch(widget.postID, list_comments);
  }

  double commentheight = 0;
  TextEditingController controller_message = TextEditingController();

  List<Widget> list_comments = [];
  Future<void> getcommentsfetch(int PostID, List<Widget> list_comments) async {
    setState(() {
      list_comments.clear();
      list_comments.add(CircularProgressIndicator());
    });
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.commentsfetch(PostID);
    if (response["durum"] == 0) {
      print(response["aciklama"]);
      return;
    }

    setState(() {
      list_comments.clear();
    });

    for (int i = 0; i < response["icerik"].length; i++) {
      setState(() {
        String displayname = response["icerik"][i]["yorumcuadsoyad"].toString();
        String avatar = response["icerik"][i]["yorumcuminnakavatar"].toString();
        String text = response["icerik"][i]["yorumcuicerik"].toString();
        int islike = response["icerik"][i]["benbegendim"];
        int yorumID = response["icerik"][i]["yorumID"];
        int userID = response["icerik"][i]["yorumcuid"];
        int postID = response["icerik"][i]["paylasimID"];
        list_comments.add(
          Widget_PostComments(
            comment: text,
            commentID: yorumID,
            displayname: displayname,
            userID: userID,
            profileImageUrl: avatar,
            islike: islike,
            postID: postID,
            username: text,
          ),
        );
      });
    }

    if (list_comments.length >= 6) {
      commentheight = Screen.screenHeight * 0.6;
    } else if (list_comments.length >= 4) {
      commentheight = Screen.screenHeight * 0.4;
    } else {
      commentheight = Screen.screenHeight * 0.2;
    }
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
      isPostdetail: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paylaşım', style: TextStyle(fontSize: 18)),
        toolbarHeight: 40,
      ),
      body: Column(children: [
        Expanded(
          child: ListView(
            children: [
              asa,
              SizedBox(
                height: commentheight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    // controller: _scrollController,
                    itemCount: list_comments.length,
                    itemBuilder: (context, index) {
                      return list_comments[index];
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(User.avatar),
                  radius: 20),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                height: 50,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: controller_message,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Mesaj yaz',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () async {
                  print(controller_message.text);
                  FunctionsPosts funct = FunctionsPosts();
                  Map<String, dynamic> response = await funct.createcomment(
                      widget.postID, controller_message.text);
                  if (response["durum"] == 0) {
                    print(response["aciklama"]);
                    return;
                  }
                  getcommentsfetch(widget.postID, list_comments);

                  controller_message.text = "";
                },
                child: Icon(
                  Icons.send,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
