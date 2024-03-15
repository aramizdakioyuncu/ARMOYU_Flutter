// ignore_for_file: must_be_immutable, use_build_context_synchronously, unused_local_variable

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/Skeletons/comments_skeleton.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:ARMOYU/Widgets/likers.dart';
import 'package:ARMOYU/Widgets/post_comments.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';

class TwitterPostWidget extends StatefulWidget {
  final int userID;
  final String profileImageUrl;
  final String username;
  final int postID;
  final String sharedDevice;

  final String postText;
  final String postDate;
  final List<Media> media;

  int postlikeCount;
  int postcommentCount;

  bool postMelike;
  bool postMecomment;
  bool? isPostdetail = false;

  TwitterPostWidget({
    super.key,
    required this.userID,
    required this.profileImageUrl,
    required this.username,
    required this.postID,
    required this.sharedDevice,
    required this.postText,
    required this.postDate,
    required this.media,
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
  TextEditingController controllerMessage = TextEditingController();

  bool likeunlikeProcces = false;
  bool postVisible = true;

//Comment Buton
  Icon postcommentIcon = const Icon(Icons.comment_outlined);
  Color postcommentColor = Colors.grey;

//Repost Buton
  Icon postrepostIcon = const Icon(Icons.cyclone_outlined);
  Color postrepostColor = Colors.grey;

  Future<void> getcommentsfetch(int postID, List<Widget> listComments) async {
    if (listComments.isEmpty) {
      setState(() {
        listComments.clear();
        listComments.add(const SkeletonComments());
        listComments.add(const SkeletonComments());
        listComments.add(const SkeletonComments());
      });
    }

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
  }

  Future<void> getcommentslikes(
      int postID, List<Widget> listCommentsLikes) async {
    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.postlikeslist(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      return;
    }
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    setState(() {
      listCommentsLikes.clear();
    });

    for (int i = 0; i < response["icerik"].length; i++) {
      setState(() {
        String displayname = response["icerik"][i]["begenenadi"].toString();
        String avatar = response["icerik"][i]["begenenavatar"].toString();
        String text = response["icerik"][i]["begenmezaman"].toString();
        int userID = response["icerik"][i]["begenenID"];
        listCommentsLikes.add(
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

  void postcomments(int postID, List<Widget> listComments) {
    //Yorumları Çekmeye başla
    getcommentsfetch(postID, listComments);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: ARMOYU.bacgroundcolor,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () async {
              getcommentsfetch(postID, listComments);
            },
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomText.costum1("YORUMLAR"),
                    const SizedBox(height: 5),
                    const Divider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: listComments.isEmpty
                              ? CustomText.costum1(
                                  "Yorum yok ilk yorumu sen yaz.")
                              : ListView.builder(
                                  itemCount: listComments.length,
                                  itemBuilder: (context, index) {
                                    return listComments[index];
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
                              foregroundImage: CachedNetworkImageProvider(
                                  ARMOYU.Appuser.avatar!.mediaURL.minURL),
                              radius: 20),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            height: 55,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color: ARMOYU.bacgroundcolor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  controller: controllerMessage,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
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
                              Map<String, dynamic> response =
                                  await funct.createcomment(
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

  void aapostLike(widgetlike, postID) async {
    if (likeunlikeProcces) {
      return;
    }

    likeunlikeProcces = true;

    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.like(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      setState(() {
        widgetlike = widgetlike;
        widget.postlikeCount = widget.postlikeCount;
      });
      return;
    }
    setState(() {
      widget.postMelike = true;
      widget.postlikeCount++;
    });
    likeunlikeProcces = false;
  }

  void aa2postLike(widgetlike, postID) async {
    if (likeunlikeProcces) {
      return;
    }
    likeunlikeProcces = true;

    FunctionsPosts funct = FunctionsPosts();
    Map<String, dynamic> response = await funct.unlike(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      setState(() {
        widgetlike = widgetlike;
        widget.postlikeCount = widget.postlikeCount;
      });
      return;
    }
    setState(() {
      widget.postMelike = false;
      widget.postlikeCount--;
    });

    likeunlikeProcces = false;
  }

  Future<bool> postLike(bool isLiked) async {
    if (isLiked) {
      if (likeunlikeProcces) {
        return isLiked;
      }
      //Beğenmeme fonksiyonu
      aa2postLike(widget.postMelike, widget.postID);
    } else {
      aapostLike(widget.postMelike, widget.postID);
    }
    return !isLiked;
  }

  void postcommentlikeslist(List<Widget> listCommentsLikes) {
    //Yorumları Çekmeye başla
    getcommentslikes(widget.postID, listCommentsLikes);

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
              getcommentslikes(widget.postID, listCommentsLikes);
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text("BEĞENENLER"),
                    const SizedBox(height: 5),
                    const Divider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          // controller: _scrollController,
                          itemCount: listCommentsLikes.length,
                          itemBuilder: (context, index) {
                            return listCommentsLikes[index];
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
                    visible: widget.userID == ARMOYU.Appuser.userID,
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
                  const Visibility(
                    //Çizgi ekler
                    child: Divider(),
                  ),
                  Visibility(
                    visible: widget.userID != ARMOYU.Appuser.userID,
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
                    visible: widget.userID != ARMOYU.Appuser.userID,
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
                    visible: widget.userID == ARMOYU.Appuser.userID,
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
                          } catch (e) {
                            log(e.toString());
                          }
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

  List<Widget> listCommentsLikes = [];
  List<Widget> listComments = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postMecomment == true) {
      postcommentIcon = const Icon(Icons.comment);
      postcommentColor = Colors.blue;
    }

    if (widget.postMecomment == true) {
      postrepostIcon = const Icon(Icons.cyclone);
      postrepostColor = Colors.green;
    }

    return Visibility(
      visible: postVisible,
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: ARMOYU.bacgroundcolor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(userID: widget.userID, appbar: true),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      foregroundImage:
                          CachedNetworkImageProvider(widget.profileImageUrl),
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText.costum1(widget.username,
                                size: 16, weight: FontWeight.bold),
                            widget.sharedDevice == "mobil"
                                ? const Text(" 📱")
                                : const Text(" 🌐")
                          ],
                        ),
                        CustomText.costum1(widget.postDate,
                            size: 16, weight: FontWeight.normal),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: postfeedback,
                        icon: const Icon(Icons.more_vert),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: specialText(context, widget.postText),
            ),
            const SizedBox(height: 5),
            Center(
              child: _buildMediaContent(context),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onLongPress: () {
                      if (widget.isPostdetail == false) {
                        postcommentlikeslist(listCommentsLikes);
                      }
                    },
                    child: LikeButton(
                      isLiked: widget.postMelike,
                      likeCount: widget.postlikeCount,
                      onTap: (isLiked) async {
                        return await postLike(isLiked);
                      },
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 25,
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    iconSize: 25,
                    icon: postcommentIcon,
                    color: postcommentColor,
                    onPressed: () {
                      postcomments(widget.postID, listComments);
                    },
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.postcommentCount.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ), // Yorum simgesi
                  const Spacer(),
                  IconButton(
                    iconSize: 25,
                    icon: postrepostIcon,
                    color: postrepostColor,
                    onPressed: () {},
                  ), // Retweet simgesi (yeşil renkte)
                  const Spacer(),
                  const Icon(Icons.share_outlined,
                      color: Colors.grey), // Paylaşım simgesi
                  const Spacer(),
                ],
              ),
            ),
          ],
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
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }

    Widget mediayerlesim = const Row();

    if (widget.media.isNotEmpty) {
      List<Row> mediaItems = [];

      List<Widget> mediarow1 = [];
      List<Widget> mediarow2 = [];

      for (int i = 0; i < widget.media.length; i++) {
        if (i > 3) {
          continue;
        }

        List media = widget.media[i].mediaType!.split('/');

        //video
        if (media[0] == "video") {
          continue;
        }

        if (media[0] == "video") {
          mediarow1.add(
            mediaSablon(widget.media[i].mediaURL.normalURL, isvideo: true),
          );
          mediaItems.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: mediarow1,
          ));
          break;
        }
        BoxFit mediadirection = BoxFit.contain;
        if (widget.media[i].mediaDirection.toString() == "dikey") {
          mediadirection = BoxFit.cover;
        }

        double mediawidth = ARMOYU.screenWidth;
        double mediaheight = ARMOYU.screenHeight;
        if (widget.media.length == 1) {
          mediawidth = mediawidth / 1;

          mediaheight = mediaheight / 2;
        } else if (widget.media.length == 2) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        } else if (widget.media.length == 3) {
          if (i == 0) {
            mediawidth = mediawidth / 1;
            mediaheight = mediaheight / 2.5;
          } else {
            mediawidth = mediawidth / 2;
            mediaheight = mediaheight / 4;
          }
        } else if (widget.media.length >= 4) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        }

        GestureDetector aa = GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MediaViewer(
                  media: widget.media,
                  initialIndex: i,
                ),
              ),
            );
          },
          child: mediaSablon(
            widget.media[i].mediaURL.normalURL,
            width: mediawidth,
            height: mediaheight,
          ),
        );
        if (widget.media.length == 3) {
          if (i == 0) {
            mediarow1.add(aa);
          } else {
            mediarow2.add(aa);
          }
        } else if (widget.media.length >= 4) {
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
      mediayerlesim = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mediaItems,
      );
    }
    return mediayerlesim;
  }
}
