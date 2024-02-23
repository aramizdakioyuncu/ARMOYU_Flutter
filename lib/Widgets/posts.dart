// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sort_child_properties_last, must_be_immutable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/Skeletons/comments_skeleton.dart';
import 'package:ARMOYU/Widgets/Utility.dart';
import 'package:ARMOYU/Widgets/likers.dart';
import 'package:ARMOYU/Widgets/post-comments.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Screens/Utility/FullScreenImagePage.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';

class TwitterPostWidget extends StatefulWidget {
  final int userID;
  final String profileImageUrl;
  final String username;
  final int postID;

  final String postText;
  final String postDate;
  final List<int> mediaIDs;
  final List<int> mediaownerIDs;
  final List<String> mediaUrls;
  final List<String> mediabetterUrls;
  final List<String> mediatype;
  final List<String> mediadirection;
  int postlikeCount;
  int postcommentCount;

  int postMelike;
  final int postMecomment;
  bool? isPostdetail = false;

  TwitterPostWidget({
    required this.userID,
    required this.profileImageUrl,
    required this.username,
    required this.postID,
    required this.postText,
    required this.postDate,
    required this.mediaIDs,
    required this.mediaownerIDs,
    required this.mediaUrls,
    required this.mediabetterUrls,
    required this.mediatype,
    required this.mediadirection,
    required this.postlikeCount,
    required this.postcommentCount,
    required this.postMelike,
    required this.postMecomment,
    this.isPostdetail,
  });

  @override
  State<TwitterPostWidget> createState() => _TwitterPostWidgetState();
}

class _TwitterPostWidgetState extends State<TwitterPostWidget> {
  TextEditingController controller_message = TextEditingController();

  bool postVisible = true;
  //Like Buton
  Icon postlikeIcon = Icon(Icons.favorite_outline);
  Color postlikeColor = Colors.grey;

//Comment Buton
  Icon postcommentIcon = Icon(Icons.comment_outlined);
  Color postcommentColor = Colors.grey;

//Repost Buton
  Icon postrepostIcon = Icon(Icons.cyclone_outlined);
  Color postrepostColor = Colors.grey;

  Future<void> getcommentsfetch(int PostID, List<Widget> list_comments) async {
    if (list_comments.isEmpty) {
      setState(() {
        list_comments.clear();
        list_comments.add(SkeletonComments());
        list_comments.add(SkeletonComments());
        list_comments.add(SkeletonComments());
      });
    }

    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.commentsfetch(PostID);
    if (response["durum"] == 0) {
      print(response["aciklama"]);
      return;
    }
    if (mounted) {
      setState(() {
        list_comments.clear();
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
              commentslikecount: commentlikescount,
            ),
          );
        });
      }
    }
  }

  Future<void> getcommentslikes(
      int PostID, List<Widget> list_comments_likes) async {
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.postlikeslist(PostID);
    if (response["durum"] == 0) {
      print(response["aciklama"].toString());
      return;
    }
    if (response["durum"] == 0) {
      print(response["aciklama"]);
      return;
    }
    setState(() {
      list_comments_likes.clear();
    });

    for (int i = 0; i < response["icerik"].length; i++) {
      setState(() {
        String displayname = response["icerik"][i]["begenenadi"].toString();
        String avatar = response["icerik"][i]["begenenavatar"].toString();
        String text = response["icerik"][i]["begenmezaman"].toString();
        int userID = response["icerik"][i]["begenenID"];
        list_comments_likes.add(
          LikersListWidget(
            comment: text,
            commentID: 1,
            displayname: displayname,
            userID: userID,
            profileImageUrl: avatar,
            islike: 1,
            postID: 12,
            username: text,
          ),
        );
      });
    }
  }

  void postcomments(int PostID, List<Widget> list_comments) {
    //Yorumları Çekmeye başla
    getcommentsfetch(PostID, list_comments);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () async {
              getcommentsfetch(PostID, list_comments);
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    CustomText().Costum1("YORUMLAR"),
                    SizedBox(height: 5),
                    Divider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: list_comments.isEmpty
                              ? CustomText()
                                  .Costum1("Yorum yok ilk yorumu sen yaz.")
                              : ListView.builder(
                                  itemCount: list_comments.length,
                                  itemBuilder: (context, index) {
                                    return list_comments[index];
                                  },
                                ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              foregroundImage:
                                  CachedNetworkImageProvider(User.avatar),
                              radius: 20),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            height: 55,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  controller: controller_message,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
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
                              Map<String, dynamic> response =
                                  await funct.createcomment(
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return;
  }

  Future<void> post_like({bool onlyLike = false}) async {
    if (onlyLike) {
      if (postlikeColor == Colors.red) {
        return;
      }
    }
    if (mounted) {
      setState(() {
        if (postlikeColor == Colors.red) {
          postlikeColor = Colors.grey;
          postlikeIcon = Icon(Icons.favorite_border);
          widget.postlikeCount--;
          widget.postMelike = 0;
        } else {
          postlikeColor = Colors.red;
          postlikeIcon = Icon(Icons.favorite_sharp);
          widget.postlikeCount++;
          widget.postMelike = 1;
        }
      });
    }
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.likeordislike(widget.postID);
    if (response["durum"] == 0) {
      print(response["aciklama"].toString());
      setState(() {
        if (postlikeColor == Colors.red) {
          postlikeColor = Colors.grey;
          postlikeIcon = Icon(Icons.favorite_border);
          widget.postlikeCount--;
          widget.postMelike = 0;
        } else {
          postlikeColor = Colors.red;
          postlikeIcon = Icon(Icons.favorite_sharp);
          widget.postlikeCount++;
          widget.postMelike = 1;
        }
      });
      return;
    }
    setState(() {
      if (response['aciklama'] == "Paylaşımı beğendin.") {
        widget.postMelike = 1;
        postlikeColor = Colors.red;
        postlikeIcon = Icon(Icons.favorite_sharp);
      } else {
        widget.postMelike = 0;
        postlikeColor = Colors.grey;
        postlikeIcon = Icon(Icons.favorite_border);
      }
    });
  }

  void postcommentlikeslist(List<Widget> list_comments_likes) {
    //Yorumları Çekmeye başla
    getcommentslikes(widget.postID, list_comments_likes);

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () async {
              getcommentslikes(widget.postID, list_comments_likes);
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text("BEĞENENLER"),
                    SizedBox(height: 5),
                    Divider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          // controller: _scrollController,
                          itemCount: list_comments_likes.length,
                          itemBuilder: (context, index) {
                            return list_comments_likes[index];
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return;
  }

  void postfeedback() {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      width: ARMOYU.screenWidth / 4,
                      height: 5,
                    ),
                  ),
                  Visibility(
                    child: InkWell(
                      onTap: () async {
                        FunctionsPosts funct = FunctionsPosts();
                        Map<String, dynamic> response =
                            await funct.remove(widget.postID);
                        if (response["durum"] == 0) {
                          log(response["aciklama"]);
                          return;
                        }
                        log(response["aciklama"]);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.star_rate_sharp,
                        ),
                        title: Text("Favorilere Ekle"),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.userID == User.ID,
                    child: InkWell(
                      onTap: () async {},
                      child: const ListTile(
                        leading: Icon(
                          Icons.edit_note_sharp,
                        ),
                        title: Text("Paylaşımı Düzenle."),
                      ),
                    ),
                  ),
                  Visibility(
                    //Çizgi ekler
                    child: const Divider(),
                  ),
                  Visibility(
                    visible: widget.userID != User.ID,
                    child: InkWell(
                      onTap: () {},
                      child: const ListTile(
                        textColor: Colors.red,
                        leading: Icon(
                          Icons.flag,
                          color: Colors.red,
                        ),
                        title: Text("Şikayet Et."),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.userID != User.ID,
                    child: InkWell(
                      onTap: () {},
                      child: const ListTile(
                        textColor: Colors.red,
                        leading: Icon(
                          Icons.person_off_outlined,
                          color: Colors.red,
                        ),
                        title: Text("Kullanıcıyı Engelle."),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.userID == User.ID,
                    child: InkWell(
                      onTap: () async {
                        FunctionsPosts funct = FunctionsPosts();
                        Map<String, dynamic> response =
                            await funct.remove(widget.postID);
                        if (response["durum"] == 0) {
                          log(response["aciklama"]);
                          return;
                        }
                        if (response["durum"] == 1) {
                          log(response["aciklama"]);
                          setState(() {
                            postVisible = false;
                          });
                          try {
                            Navigator.pop(context);
                          } catch (e) {}
                        }
                      },
                      child: const ListTile(
                        textColor: Colors.red,
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text("Paylaşımı Sil."),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> list_comments_likes = [];
  List<Widget> list_comments = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postMelike == 1) {
      postlikeIcon = Icon(Icons.favorite);
      postlikeColor = Colors.red;
    }

    if (widget.postMecomment == 1) {
      postcommentIcon = Icon(Icons.comment);
      postcommentColor = Colors.blue;
    }

    if (widget.postMecomment == 1) {
      postrepostIcon = Icon(Icons.cyclone);
      postrepostColor = Colors.green;
    }

    return Visibility(
      visible: postVisible,
      child: Container(
        margin: EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: ARMOYU.bodyColor,
        ),
        child: GestureDetector(
          onDoubleTap: () {
            post_like(onlyLike: true);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  post_like(onlyLike: true);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      userID: widget.userID, appbar: true)));
                        },
                        child: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                              widget.profileImageUrl),
                          radius: 20,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText().Costum1(widget.username,
                                size: 16, weight: FontWeight.bold),
                            CustomText().Costum1(widget.postDate,
                                size: 16, weight: FontWeight.normal),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: postfeedback,
                            icon: Icon(Icons.more_vert),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: GestureDetector(
                    onDoubleTap: () {
                      post_like(onlyLike: true);
                    },
                    child: specialText(context, widget.postText)),
              ),
              SizedBox(height: 5),
              Center(
                child: _buildMediaContent(context),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                child: Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onLongPress: () {
                        if (widget.isPostdetail == false) {
                          postcommentlikeslist(list_comments_likes);
                        }
                      },
                      child: IconButton(
                        iconSize: 25,
                        icon: postlikeIcon,
                        color: postlikeColor,
                        onPressed: () async {
                          await post_like();
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        if (widget.isPostdetail == false) {
                          postcommentlikeslist(list_comments_likes);
                        }
                      },
                      onLongPress: () {
                        if (widget.isPostdetail == false) {
                          postcommentlikeslist(list_comments_likes);
                        }
                      },
                      child: Text(
                        widget.postlikeCount.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      iconSize: 25,
                      icon: postcommentIcon,
                      color: postcommentColor,
                      onPressed: () {
                        postcomments(widget.postID, list_comments);
                      },
                    ),
                    SizedBox(width: 5),
                    Text(
                      widget.postcommentCount.toString(),
                      style: TextStyle(color: Colors.grey),
                    ), // Yorum simgesi
                    Spacer(),
                    IconButton(
                      iconSize: 25,
                      icon: postrepostIcon,
                      color: postrepostColor,
                      onPressed: () {},
                    ), // Retweet simgesi (yeşil renkte)
                    Spacer(),
                    Icon(Icons.share_outlined,
                        color: Colors.grey), // Paylaşım simgesi
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    Widget mediaSablon(String mediaUrl,
        {BoxFit? fit = BoxFit.cover,
        double? width = 100,
        double? height = 100,
        bool? isvideo = false}) {
      if (isvideo == true) {
        // mediaUrl
        final chewieController = ChewieController(
          videoPlayerController:
              VideoPlayerController.networkUrl(Uri.parse(mediaUrl)),
          autoPlay: false,
          looping: false,
        );
        return Chewie(
          controller: chewieController,
        );
      }
      return CachedNetworkImage(
        imageUrl: mediaUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }

    Widget Mediayerlesim = Row();

    if (widget.mediaUrls.isNotEmpty) {
      List<Row> mediaItems = [];

      List<Widget> mediarow1 = [];
      List<Widget> mediarow2 = [];

      for (int i = 0; i < widget.mediaUrls.length; i++) {
        if (i > 3) {
          continue;
        }

        List media = widget.mediatype[i].split('/');

        //video
        if (media[0] == "video") {
          continue;
        }

        if (media[0] == "video") {
          mediarow1.add(
            mediaSablon(widget.mediaUrls[i], isvideo: true),
          );
          mediaItems.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: mediarow1,
          ));
          break;
        }
        BoxFit mediadirection = BoxFit.contain;
        if (widget.mediadirection[i].toString() == "dikey") {
          mediadirection = BoxFit.cover;
        }

        double mediawidth = ARMOYU.screenWidth;
        double mediaheight = ARMOYU.screenHeight;
        if (widget.mediaUrls.length == 1) {
          mediawidth = mediawidth / 1;

          mediaheight = mediaheight / 2;
        } else if (widget.mediaUrls.length == 2) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        } else if (widget.mediaUrls.length == 3) {
          if (i == 0) {
            mediawidth = mediawidth / 1;
            mediaheight = mediaheight / 2.5;
          } else {
            mediawidth = mediawidth / 2;
            mediaheight = mediaheight / 4;
          }
        } else if (widget.mediaUrls.length >= 4) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        }

        GestureDetector aa = GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FullScreenImagePage(
                images: widget.mediabetterUrls,
                imagesID: widget.mediaIDs,
                imagesownerID: widget.mediaownerIDs,
                initialIndex: i,
              ),
            ));
          },
          onDoubleTap: () {
            post_like(onlyLike: true);
          },
          child: mediaSablon(widget.mediaUrls[i],
              width: mediawidth, height: mediaheight),
        );
        if (widget.mediaUrls.length == 3) {
          if (i == 0) {
            mediarow1.add(aa);
          } else {
            mediarow2.add(aa);
          }
        } else if (widget.mediaUrls.length >= 4) {
          if (i == 0 || i == 1) {
            mediarow1.add(aa);
          } else {
            mediarow2.add(aa);
          }
        } else {
          mediarow1.add(aa);
        }
      }
      mediaItems.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mediarow1,
      ));
      mediaItems.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mediarow2,
      ));
      /////////////////////////////////////////////////

      /////////////////////////////////////////////////
      Mediayerlesim = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mediaItems,
      );
    }
    return Mediayerlesim;
  }
}
