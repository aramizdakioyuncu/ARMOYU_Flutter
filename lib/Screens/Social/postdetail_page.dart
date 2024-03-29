import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/post.dart';
import 'package:ARMOYU/Models/user.dart';

import 'package:ARMOYU/Widgets/post_comments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Widgets/posts.dart';

class PostDetailPage extends StatefulWidget {
  final int postID;

  const PostDetailPage({
    super.key,
    required this.postID,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPage();
}

class _PostDetailPage extends State<PostDetailPage>
    with AutomaticKeepAliveClientMixin<PostDetailPage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    postdetailfetch();
    getcommentsfetch(widget.postID, listComments);
  }

  double commentheight = 0;
  TextEditingController controllerMessage = TextEditingController();

  List<Widget> listComments = [];
  Future<void> getcommentsfetch(int postID, List<Widget> listComments) async {
    setState(() {
      listComments.clear();
      listComments.add(const CircularProgressIndicator());
    });
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.commentsfetch(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    if (mounted) {
      setState(() {
        listComments.clear();
      });
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      if (mounted) {
        setState(() {
          String displayname =
              response["icerik"][i]["yorumcuadsoyad"].toString();
          String avatar =
              response["icerik"][i]["yorumcuminnakavatar"].toString();
          String text = response["icerik"][i]["yorumcuicerik"].toString();
          int islike = response["icerik"][i]["benbegendim"];
          int yorumID = response["icerik"][i]["yorumID"];
          int userID = response["icerik"][i]["yorumcuid"];
          int postID = response["icerik"][i]["paylasimID"];
          int commentlikescount = response["icerik"][i]["yorumbegenisayi"];

          listComments.add(
            WidgetPostComments(
              comment: text,
              commentID: yorumID,
              displayname: displayname,
              userID: userID,
              profileImageUrl: avatar,
              islike: islike,
              postID: postID,
              username: text,
              commentslikecount: commentlikescount,
            ),
          );
        });
      }
    }

    if (listComments.length >= 6) {
      commentheight = ARMOYU.screenHeight * 0.6;
    } else if (listComments.length >= 4) {
      commentheight = ARMOYU.screenHeight * 0.4;
    } else {
      commentheight = ARMOYU.screenHeight * 0.2;
    }
  }

  Widget asa = const Text("");
  Future<void> postdetailfetch() async {
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.detailfetch(widget.postID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    List<Media> media = [];

    if (response["icerik"][0]["paylasimfoto"].length != 0) {
      int mediaItemCount = response["icerik"][0]["paylasimfoto"].length;

      for (int j = 0; j < mediaItemCount; j++) {
        media.add(
          Media(
            mediaID: response["icerik"][0]["paylasimfoto"][j]["fotoID"],
            ownerID: response["icerik"][0]["sahipID"],
            mediaType: response["icerik"][0]["paylasimfoto"][j]
                ["paylasimkategori"],
            mediaDirection: response["icerik"][0]["paylasimfoto"][j]
                ["medyayonu"],
            mediaURL: MediaURL(
                bigURL: response["icerik"][0]["paylasimfoto"][j]["fotoufakurl"],
                normalURL: response["icerik"][0]["paylasimfoto"][j]
                    ["fotominnakurl"],
                minURL: response["icerik"][0]["paylasimfoto"][j]
                    ["fotominnakurl"]),
          ),
        );
      }
    }
    Post post = Post(
      postID: response["icerik"][0]["paylasimID"],
      content: response["icerik"][0]["paylasimicerik"],
      postDate: response["icerik"][0]["paylasimzamangecen"],
      sharedDevice: response["icerik"][0]["paylasimnereden"],
      likesCount: response["icerik"][0]["begenisay"],
      isLikeme: response["icerik"][0]["benbegendim"],
      commentsCount: response["icerik"][0]["yorumsay"],
      iscommentMe: response["icerik"][0]["benyorumladim"],
      media: media,
      owner: User(
        userID: response["icerik"][0]["sahipID"],
        userName: response["icerik"][0]["sahipad"],
        avatar: Media(
          mediaURL: MediaURL(
            bigURL: response["icerik"][0]["sahipavatarminnak"],
            normalURL: response["icerik"][0]["sahipavatarminnak"],
            minURL: response["icerik"][0]["sahipavatarminnak"],
          ),
        ),
      ),
    );
    asa = TwitterPostWidget(
      // userID: response["icerik"][0]["sahipID"],
      // profileImageUrl: response["icerik"][0]["sahipavatarminnak"],
      // username: response["icerik"][0]["sahipad"],
      // sharedDevice: response["icerik"][0]["paylasimnereden"],
      // postID: response["icerik"][0]["paylasimID"],
      // postText: response["icerik"][0]["paylasimicerik"],
      // postDate: response["icerik"][0]["paylasimzamangecen"],
      // media: media,
      // postlikeCount: response["icerik"][0]["begenisay"],
      // postcommentCount: response["icerik"][0]["yorumsay"],
      // postMecomment: response["icerik"][0]["benyorumladim"],
      // postMelike: response["icerik"][0]["benbegendim"],
      // isPostdetail: true,
      post: post,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      appBar: AppBar(
        title: const Text('Paylaşım', style: TextStyle(fontSize: 18)),
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
                    itemCount: listComments.length,
                    itemBuilder: (context, index) {
                      return listComments[index];
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
                  foregroundImage: CachedNetworkImageProvider(
                      ARMOYU.Appuser.avatar!.mediaURL.minURL),
                  radius: 20),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                height: 50,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: controllerMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Mesaj yaz',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () async {
                  log(controllerMessage.text);
                  FunctionsPosts funct = FunctionsPosts();
                  Map<String, dynamic> response = await funct.createcomment(
                      widget.postID, controllerMessage.text);
                  if (response["durum"] == 0) {
                    log(response["aciklama"]);
                    return;
                  }
                  getcommentsfetch(widget.postID, listComments);

                  controllerMessage.text = "";
                },
                child: const Icon(
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
