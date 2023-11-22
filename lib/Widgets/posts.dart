// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sort_child_properties_last, must_be_immutable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:developer';
import 'package:ARMOYU/Core/screen.dart';
import 'package:ARMOYU/Screens/Social/postdetail_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/likers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../Functions/posts.dart';
import '../Screens/FullScreenImagePage.dart';
import '../Screens/Profile/profile_page.dart';

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
  int postlikeCount;
  int postcommentCount;

  int postMelike;
  final int postMecomment;

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
    required this.postlikeCount,
    required this.postcommentCount,
    required this.postMelike,
    required this.postMecomment,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list_comments = [];
    Future<void> getcommentsfetch() async {
      setState(() {
        list_comments.clear();
        list_comments.add(CircularProgressIndicator());
      });
      FunctionsPosts funct = FunctionsPosts();
      Map<String, dynamic> response = await funct.commentsfetch(widget.postID);
      if (response["durum"] == 0) {
        print(response["aciklama"]);
        return;
      }
      list_comments.clear();
      for (int i = 0; i < response["icerik"].length; i++) {
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
          list_comments.add(
            LikersListWidget(
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
    }

    List<Widget> list_comments_likes = [];
    Future<void> getcommentslikes() async {
      FunctionsPosts funct = FunctionsPosts();
      Map<String, dynamic> response = await funct.postlikeslist(widget.postID);
      if (response["durum"] == 0) {
        print(response["aciklama"].toString());
        return;
      }
      if (response["durum"] == 0) {
        print(response["aciklama"]);
        return;
      }
      list_comments_likes.clear();
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

    //
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

    void postcomments() {
      //Yorumları Çekmeye başla
      getcommentsfetch();
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
                getcommentsfetch();
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text("YORUMLAR"),
                      SizedBox(height: 5),
                      Divider(),
                      Expanded(
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

    void postcommentlikeslist() {
      //Yorumları Çekmeye başla
      getcommentslikes();

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
                getcommentslikes();
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
                        width: Screen.screenWidth / 4,
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
                            Navigator.pop(context);
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

    return Visibility(
      visible: postVisible,
      child: Container(
        // padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade900,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostDetailPage(
                              postID: widget.postID,
                            )));
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
                          radius: 20),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.postDate,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
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
              child: _buildPostText(),
            ), // Tıklanabilir metin için yeni fonksiyon
            SizedBox(height: 5),
            Center(
              child: _buildMediaContent(context),
            ), // Medya içeriği için yeni fonksiyon

            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    iconSize: 25,
                    icon: postlikeIcon,
                    color: postlikeColor,
                    onPressed: () async {
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
                      FunctionsPosts funct = FunctionsPosts();
                      Map<String, dynamic> response =
                          await funct.likeordislike(widget.postID);
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
                    },
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      postcommentlikeslist();
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
                      postcomments();
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
    );
  }

  Widget _buildPostText() {
    final words = widget.postText.split(' ');

    final textSpans = words.map((word) {
      if (word.startsWith('#')) {
        return TextSpan(
          text: word + ' ',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Burada # işaretine tıklandığında yapılacak işlemi ekleyin
              print('Tapped on hashtag: $word');
            },
        );
      }

      if (word.startsWith('@')) {
        return TextSpan(
          text: word + ' ',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Burada @ işaretine tıklandığında yapılacak işlemi ekleyin
              print('Tapped on hashtag: $word');

              List getusername = word.split('@');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(username: getusername[1], appbar: true)));
            },
        );
      }
      return TextSpan(text: word + ' ');
    }).toList();

    return RichText(
      text: TextSpan(
        children: textSpans,
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
        // placeholder: (context, url) => CircularProgressIndicator(),
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

        if (widget.mediatype[i] == 12) {}
        double mediawidth = Screen.screenWidth;
        double mediaheight = Screen.screenHeight;
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
