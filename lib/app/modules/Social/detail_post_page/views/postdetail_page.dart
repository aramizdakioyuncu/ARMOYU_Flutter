import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';

import 'package:ARMOYU/app/widgets/post_comments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ARMOYU/app/functions/API_Functions/posts.dart';
import 'package:ARMOYU/app/widgets/posts/views/post_view.dart';

class PostDetailPage extends StatefulWidget {
  final UserAccounts currentUserAccounts;
  final int? postID;
  final int? commentID;

  const PostDetailPage({
    super.key,
    required this.currentUserAccounts,
    this.postID,
    this.commentID,
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

    log(widget.commentID.toString());
    postdetailfetch();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  double commentheight = 0;
  TextEditingController controllerMessage = TextEditingController();

  List<Widget> listComments = [];
  Future<void> getcommentsfetch(int postID, List<Widget> listComments) async {
    listComments.clear();
    listComments.add(
      const CupertinoActivityIndicator(),
    );

    setstatefunction();
    FunctionsPosts funct =
        FunctionsPosts(currentUser: widget.currentUserAccounts.user);
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
              currentUserAccounts: widget.currentUserAccounts,
              comment: Comment(
                commentID: yorumID,
                content: text,
                didIlike: islike == 1 ? true : false,
                likeCount: commentlikescount,
                postID: postID,
                user: User(
                  userID: userID,
                  displayName: displayname,
                  avatar: Media(
                    mediaID: userID,
                    mediaURL: MediaURL(
                      bigURL: avatar,
                      normalURL: avatar,
                      minURL: avatar,
                    ),
                  ),
                ),
                date: "",
              ),
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
    FunctionsPosts funct =
        FunctionsPosts(currentUser: widget.currentUserAccounts.user);
    Map<String, dynamic> response = await funct.detailfetch(
      postID: widget.postID,
      category: "yorum",
      categoryDetail: widget.commentID,
    );
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    List<Media> media = [];
    List<Comment> comments = [];
    List<Like> likers = [];

    getcommentsfetch(response["icerik"][0]["paylasimID"], listComments);

    if (response["icerik"][0]["paylasimfoto"].length != 0) {
      for (int j = 0; j < response["icerik"][0]["paylasimfoto"].length; j++) {
        media.add(
          Media(
            mediaID: response["icerik"][0]["paylasimfoto"][j]["fotoID"],
            ownerID: response["icerik"][0]["sahipID"],
            mediaType: response["icerik"][0]["paylasimfoto"][j]
                ["paylasimkategori"],
            mediaDirection: response["icerik"][0]["paylasimfoto"][j]
                ["medyayonu"],
            mediaURL: MediaURL(
              bigURL: response["icerik"][0]["paylasimfoto"][j]["fotourl"],
              normalURL: response["icerik"][0]["paylasimfoto"][j]
                  ["fotoufakurl"],
              minURL: response["icerik"][0]["paylasimfoto"][j]["fotominnakurl"],
            ),
          ),
        );
      }
    }

    for (var firstthreelike in response["icerik"][0]["paylasimilkucbegenen"]) {
      likers.add(
        Like(
            likeID: firstthreelike["begeni_ID"],
            user: User(
              userID: firstthreelike["ID"],
              displayName: firstthreelike["adsoyad"],
              userName: firstthreelike["kullaniciadi"],
              avatar: Media(
                mediaID: firstthreelike["ID"],
                mediaURL: MediaURL(
                  bigURL: firstthreelike["avatar"],
                  normalURL: firstthreelike["avatar"],
                  minURL: firstthreelike["avatar"],
                ),
              ),
            ),
            date: firstthreelike["begeni_zaman"]),
      );
    }

    for (var firstthreecomment in response["icerik"][0]["ilkucyorum"]) {
      comments.add(
        Comment(
            commentID: firstthreecomment["yorumID"],
            postID: firstthreecomment["paylasimID"],
            user: User(
              userID: firstthreecomment["yorumcuid"],
              displayName: firstthreecomment["yorumcuadsoyad"],
              avatar: Media(
                mediaID: firstthreecomment["yorumcuid"],
                mediaURL: MediaURL(
                  bigURL: firstthreecomment["yorumcuavatar"],
                  normalURL: firstthreecomment["yorumcuufakavatar"],
                  minURL: firstthreecomment["yorumcuminnakavatar"],
                ),
              ),
            ),
            content: firstthreecomment["yorumcuicerik"],
            likeCount: firstthreecomment["yorumbegenisayi"],
            didIlike: firstthreecomment["benbegendim"] == 1 ? true : false,
            date: firstthreecomment["yorumcuzamangecen"]),
      );
    }
    Post post = Post(
      postID: response["icerik"][0]["paylasimID"],
      content: response["icerik"][0]["paylasimicerik"],
      postDate: response["icerik"][0]["paylasimzamangecen"],
      sharedDevice: response["icerik"][0]["paylasimnereden"],
      likesCount: response["icerik"][0]["begenisay"],
      isLikeme: response["icerik"][0]["benbegendim"] == 1 ? true : false,
      commentsCount: response["icerik"][0]["yorumsay"],
      iscommentMe: response["icerik"][0]["benyorumladim"] == 1 ? true : false,
      media: media,
      owner: User(
        userID: response["icerik"][0]["sahipID"],
        userName: response["icerik"][0]["sahipad"],
        avatar: Media(
          mediaID: response["icerik"][0]["sahipID"],
          mediaURL: MediaURL(
            bigURL: response["icerik"][0]["sahipavatarminnak"],
            normalURL: response["icerik"][0]["sahipavatarminnak"],
            minURL: response["icerik"][0]["sahipavatarminnak"],
          ),
        ),
      ),
      firstthreecomment: comments,
      firstthreelike: likers,
      location: response["icerik"][0]["paylasimkonum"],
    );
    asa = TwitterPostWidget(
      currentUserAccounts: widget.currentUserAccounts,
      post: post,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paylaşım', style: TextStyle(fontSize: 18)),
        // backgroundColor: ARMOYU.appbarColor,
        toolbarHeight: 40,
      ),
      body: Column(
        children: [
          asa,
        ],
      ),
    );
  }
}
