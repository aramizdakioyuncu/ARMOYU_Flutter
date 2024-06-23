// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/Client_Functions/profile.dart';
import 'package:ARMOYU/Functions/page_functions.dart';
import 'package:ARMOYU/Models/Social/comment.dart';
import 'package:ARMOYU/Models/Social/like.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/post.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:ARMOYU/Widgets/Skeletons/comments_skeleton.dart';
import 'package:ARMOYU/Widgets/utility.dart';
import 'package:ARMOYU/Widgets/likers.dart';
import 'package:ARMOYU/Widgets/post_comments.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:video_player/video_player.dart';

import 'package:ARMOYU/Functions/API_Functions/posts.dart';

class TwitterPostWidget extends StatefulWidget {
  final User currentUser;
  final Post post;
  final bool? isPostdetail = false;

  const TwitterPostWidget({
    super.key,
    required this.currentUser,
    required this.post,
  });

  @override
  State<TwitterPostWidget> createState() => _TwitterPostWidgetState();
}

class _TwitterPostWidgetState extends State<TwitterPostWidget> {
  TextEditingController controllerMessage = TextEditingController();

  bool likeunlikeProcces = false;
  bool postVisible = true;

  //Comment Button
  Icon postcommentIcon = const Icon(Icons.comment_outlined);
  Color postcommentColor = Colors.grey;

  //Repost Button
  Icon postrepostIcon = const Icon(Icons.cyclone_outlined);
  Color postrepostColor = Colors.grey;

  bool _fetchCommentStatus = false;
  bool _fetchlikersStatus = false;

  Future<void> getcommentsfetch(int postID, {bool fetchRestart = false}) async {
    //Eğer önceden yüklenmişse tekrar yüklemeye çalışma
    if (!fetchRestart && widget.post.comments != null) {
      return;
    }

    if (_fetchCommentStatus) {
      return;
    }
    _fetchCommentStatus = true;
    setstatefunction();
    FunctionsPosts funct = FunctionsPosts(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.commentsfetch(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      _fetchCommentStatus = false;
      setstatefunction();

      return;
    }

    //Yorumları Temizle
    widget.post.comments = [];

    //Veriler çek
    for (int i = 0; i < response["icerik"].length; i++) {
      String displayname = response["icerik"][i]["yorumcuadsoyad"].toString();
      String avatar = response["icerik"][i]["yorumcuminnakavatar"].toString();
      String text = response["icerik"][i]["yorumcuicerik"].toString();
      int islike = response["icerik"][i]["benbegendim"];
      int yorumID = response["icerik"][i]["yorumID"];
      int userID = response["icerik"][i]["yorumcuid"];
      int postID = response["icerik"][i]["paylasimID"];
      int commentlikescount = response["icerik"][i]["yorumbegenisayi"];

      Comment comment = Comment(
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
      );

      //Post yorumlarına ekler
      widget.post.comments!.add(comment);
      _fetchCommentStatus = false;
      setstatefunction();
    }
  }

  Future<void> getcommentslikes(int postID, {bool fetchRestart = false}) async {
    if (!fetchRestart && widget.post.likers != null) {
      return;
    }

    if (_fetchlikersStatus) {
      return;
    }
    _fetchlikersStatus = true;
    setstatefunction();

    FunctionsPosts funct = FunctionsPosts(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.postlikeslist(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      _fetchlikersStatus = false;
      setstatefunction();
      return;
    }

    //Beğenenleri Temizle
    widget.post.likers = [];
    setstatefunction();

    for (int i = 0; i < response["icerik"].length; i++) {
      String displayname = response["icerik"][i]["begenenadi"].toString();
      String avatar = response["icerik"][i]["begenenavatar"].toString();
      String date = response["icerik"][i]["begenmezaman"].toString();
      int userID = response["icerik"][i]["begenenID"];

      widget.post.likers!.add(
        Like(
          likeID: 1,
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
          date: date,
        ),
      );
    }
    _fetchlikersStatus = false;
    setstatefunction();
  }

  Future<void> removepost() async {
    postVisible = false;
    setstatefunction();

    FunctionsPosts funct = FunctionsPosts(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.remove(widget.post.postID);

    ARMOYUWidget.toastNotification(response["aciklama"].toString());

    if (response["durum"] == 0) {
      postVisible = true;
      setstatefunction();
      return;
    }
  }

  void postcomments(int postID) {
    //Yorumları Çekmeye başla
    getcommentsfetch(postID);

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: ARMOYU.backgroundcolor,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () async => await getcommentsfetch(
              postID,
              fetchRestart: true,
            ),
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
                          child: _fetchCommentStatus &&
                                  widget.post.comments == null
                              ? const Column(
                                  children: [
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                  ],
                                )
                              : widget.post.comments!.isEmpty
                                  ? CustomText.costum1(
                                      "Yorum yok ilk yorumu sen yaz.")
                                  : ListView.builder(
                                      itemCount: widget.post.comments!.length,
                                      itemBuilder: (context, index) {
                                        return WidgetPostComments(
                                          currentUser: widget.currentUser,
                                          comment: widget.post.comments![index],
                                        );
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
                            backgroundColor: Colors.transparent,
                            foregroundImage: CachedNetworkImageProvider(
                              widget.currentUser.avatar!.mediaURL.minURL,
                            ),
                            radius: 20,
                          ),
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
                                  color: ARMOYU.backgroundcolor,
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
                              FunctionsPosts funct = FunctionsPosts(
                                  currentUser: widget.currentUser);
                              Map<String, dynamic> response =
                                  await funct.createcomment(widget.post.postID,
                                      controllerMessage.text);
                              if (response["durum"] == 0) {
                                ARMOYUWidget.toastNotification(
                                    response["aciklama"].toString());
                                return;
                              }
                              await getcommentsfetch(
                                widget.post.postID,
                                fetchRestart: true,
                              );
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

    FunctionsPosts funct = FunctionsPosts(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.like(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      setState(() {
        widgetlike = widgetlike;
        widget.post.likesCount = widget.post.likesCount;
      });
      return;
    }

    widget.post.isLikeme = true;
    widget.post.likesCount++;
    likeunlikeProcces = false;

    if (mounted) {
      setState(() {});
    }
  }

  void aa2postLike(widgetlike, postID) async {
    if (likeunlikeProcces) {
      return;
    }
    likeunlikeProcces = true;

    FunctionsPosts funct = FunctionsPosts(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.unlike(postID);
    if (response["durum"] == 0) {
      log(response["aciklama"].toString());
      setState(() {
        widgetlike = widgetlike;
        widget.post.likesCount = widget.post.likesCount;
      });
      return;
    }

    widget.post.isLikeme = false;
    widget.post.likesCount--;
    if (mounted) {
      setState(() {});
    }

    likeunlikeProcces = false;
  }

  Future<bool> postLike(bool isLiked) async {
    if (isLiked) {
      if (likeunlikeProcces) {
        return isLiked;
      }
      //Beğenmeme fonksiyonu
      aa2postLike(widget.post.isLikeme, widget.post.postID);
    } else {
      aapostLike(widget.post.isLikeme, widget.post.postID);
    }
    return !isLiked;
  }

  void postcommentlikeslist() {
    //Yorumları Çekmeye başla
    getcommentslikes(widget.post.postID);

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
            onRefresh: () => getcommentslikes(
              widget.post.postID,
              fetchRestart: true,
            ),
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
                        child: Container(
                          alignment: Alignment.center,
                          child: _fetchlikersStatus &&
                                  widget.post.likers == null
                              ? const Column(
                                  children: [
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                    SkeletonComments(),
                                  ],
                                )
                              : widget.post.likers!.isEmpty
                                  ? CustomText.costum1("Beğeni Yok")
                                  : ListView.builder(
                                      itemCount: widget.post.likers!.length,
                                      itemBuilder: (context, index) {
                                        return LikersListWidget(
                                          currentUser: widget.currentUser,
                                          date: widget.post.likers![index].date,
                                          islike: 1,
                                          user: widget.post.likers![index].user,
                                        );
                                      },
                                    ),
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
      backgroundColor: ARMOYU.backgroundcolor,
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
                        FunctionsPosts funct =
                            FunctionsPosts(currentUser: widget.currentUser);
                        Map<String, dynamic> response =
                            await funct.remove(widget.post.postID);
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
                    visible:
                        widget.post.owner.userID == widget.currentUser.userID,
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
                    visible:
                        widget.post.owner.userID != widget.currentUser.userID,
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
                    visible:
                        widget.post.owner.userID != widget.currentUser.userID,
                    child: InkWell(
                      onTap: () async {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                        ClientFunctionsProfile function =
                            ClientFunctionsProfile(
                                currentUser: widget.currentUser);
                        ARMOYUWidget.toastNotification(
                          await function.userblock(
                            widget.post.owner.userID!,
                          ),
                        );
                      },
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
                    visible:
                        widget.post.owner.userID == widget.currentUser.userID,
                    child: InkWell(
                      onTap: () async => ARMOYUWidget.showConfirmationDialog(
                        context,
                        accept: removepost,
                      ),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  final GlobalKey<LikeButtonState> _likeButtonKey =
      GlobalKey<LikeButtonState>();
  @override
  Widget build(BuildContext context) {
    if (widget.post.iscommentMe == true) {
      postcommentIcon = const Icon(Icons.comment);
      postcommentColor = Colors.blue;
    }

    if (widget.post.iscommentMe == true) {
      postrepostIcon = const Icon(Icons.cyclone);
      postrepostColor = Colors.green;
    }

    return Visibility(
      visible: postVisible,
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: ARMOYU.backgroundcolor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                onTap: () {
                  PageFunctions functions =
                      PageFunctions(currentUser: widget.currentUser);

                  functions.pushProfilePage(
                    context,
                    User(
                      userID: widget.post.owner.userID,
                    ),
                    ScrollController(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundImage: CachedNetworkImageProvider(
                        widget.post.owner.avatar!.mediaURL.minURL,
                      ),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText.costum1(
                                widget.post.owner.userName!,
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                              const SizedBox(width: 5),
                              widget.post.sharedDevice == "mobil"
                                  ? const Text("📱")
                                  : const Text("🌐"),
                              const SizedBox(width: 5),
                              CustomText.costum1(
                                widget.post.postDate,
                                weight: FontWeight.normal,
                                color: ARMOYU.textColor.withOpacity(0.69),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: widget.post.location != null,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 1),
                                    CustomText.costum1(
                                      widget.post.location.toString(),
                                      weight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
            ),
            InkWell(
              onDoubleTap: () {
                if (!widget.post.isLikeme) {
                  _likeButtonKey.currentState?.onTap();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: WidgetUtility.specialText(
                        context,
                        currentUser: widget.currentUser,
                        widget.post.content,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onDoubleTap: () {
                if (!widget.post.isLikeme) {
                  _likeButtonKey.currentState?.onTap();
                }
              },
              child: Center(
                child: _buildMediaContent(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  InkWell(
                    onLongPress: () {
                      if (widget.isPostdetail == false) {
                        postcommentlikeslist();
                      }
                    },
                    child: LikeButton(
                      key: _likeButtonKey,
                      isLiked: widget.post.isLikeme,
                      likeCount: widget.post.likesCount,
                      onTap: (isLiked) async => await postLike(isLiked),
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
                    onPressed: () => postcomments(widget.post.postID),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.post.commentsCount.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  IconButton(
                    iconSize: 25,
                    icon: postrepostIcon,
                    color: postrepostColor,
                    onPressed: () {},
                  ),
                  const Spacer(),
                  const Icon(Icons.share_outlined, color: Colors.grey),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        const SizedBox(height: 20),
                        ...List.generate(widget.post.firstthreelike.length,
                            (index) {
                          int left = widget.post.firstthreelike.length * 10 -
                              (index + 1) * 10;
                          return Positioned(
                            left: double.parse(left.toString()),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: CachedNetworkImageProvider(
                                widget
                                    .post
                                    .firstthreelike[
                                        widget.post.firstthreelike.length -
                                            index -
                                            1]
                                    .user
                                    .avatar!
                                    .mediaURL
                                    .minURL,
                              ),
                              radius: 10,
                            ),
                          );
                        }),
                        Positioned(
                          left: widget.post.firstthreelike.length * 10 + 15,
                          child: widget.post.firstthreelike.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => postcommentlikeslist(),
                                  child: WidgetUtility.specialText(
                                    context,
                                    currentUser: widget.currentUser,
                                    "@${widget.post.firstthreelike[0].user.userName.toString()} ${widget.post.likesCount - 1 > 0 ? "ve ${widget.post.likesCount - 1} kişi" : ""} beğendi",
                                    // fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: List.generate(
                        widget.post.firstthreecomment.length, (index) {
                      return widget.post.firstthreecomment[index].commentlist(
                        context,
                        setstatefunction,
                        currentUser: widget.currentUser,
                      );
                    }),
                  ),
                  Visibility(
                    visible: widget.post.commentsCount > 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => postcomments(widget.post.postID),
                        child: CustomText.costum1(
                          "${widget.post.commentsCount} yorumun tamamını gör",
                          color: ARMOYU.textColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    Widget mediaSablon(
      String mediaUrl, {
      required int indexlength,
      BoxFit? fit = BoxFit.cover,
      double? width = 100,
      double? height = 100,
      bool? isvideo = false,
      bool islastmedia = false,
    }) {
      if (isvideo == true) {
        log(mediaUrl);

        final videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(mediaUrl),
        );

        final chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoInitialize: true,
          autoPlay: false,
          aspectRatio: 9 / 16,
          // isLive: true,
          looping: false,
        );

        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: 500,
            width: ARMOYU.screenWidth - 20,
            child: chewieController.videoPlayerController.value.isInitialized
                ? const CupertinoActivityIndicator()
                : Chewie(
                    controller: chewieController,
                  ),
          ),
        );
      }
      if (islastmedia && indexlength > 4) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
              image: CachedNetworkImageProvider(
                mediaUrl,
                errorListener: (p0) => const Icon(Icons.error),
              ),
              fit: fit,
            ),
          ),
          child: Center(
              child: Text(
            "+${indexlength - 4}",
            style: const TextStyle(fontSize: 50),
          )),
        );
      } else {
        return PinchZoom(
          child: CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: fit,
            width: width,
            height: height,
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
      }
    }

    Widget mediayerlesim = const Row();

    if (widget.post.media.isNotEmpty) {
      List<Row> mediaItems = [];

      List<Widget> mediarow1 = [];
      List<Widget> mediarow2 = [];
      for (int i = 0; i < widget.post.media.length; i++) {
        if (i > 3) {
          continue;
        }

        List media = widget.post.media[i].mediaType!.split('/');

        if (media[0] == "video") {
          mediarow1.clear();
          mediarow1.add(
            mediaSablon(
              indexlength: widget.post.media.length,
              widget.post.media[i].mediaURL.normalURL,
              isvideo: true,
            ),
          );
          break;
        }

        BoxFit mediadirection = BoxFit.cover;
        if (widget.post.media[i].mediaDirection.toString() == "yatay" &&
            widget.post.media.length == 1) {
          mediadirection = BoxFit.contain;
        }

        double mediawidth = ARMOYU.screenWidth;
        double mediaheight = ARMOYU.screenHeight;
        if (widget.post.media.length == 1) {
          mediawidth = mediawidth / 1;

          mediaheight = mediaheight / 2;
        } else if (widget.post.media.length == 2) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        } else if (widget.post.media.length == 3) {
          if (i == 0) {
            mediawidth = mediawidth / 1;
            mediaheight = mediaheight / 2.5;
          } else {
            mediawidth = mediawidth / 2;
            mediaheight = mediaheight / 4;
          }
        } else if (widget.post.media.length >= 4) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        }

        GestureDetector aa = GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MediaViewer(
                  currentUser: widget.currentUser,
                  media: widget.post.media,
                  initialIndex: i,
                ),
              ),
            );
          },
          child: mediaSablon(
            indexlength: widget.post.media.length,
            widget.post.media[i].mediaURL.normalURL,
            width: mediawidth,
            height: mediaheight,
            fit: mediadirection,
            islastmedia: i == 3,
          ),
        );

        if (widget.post.media.length == 3) {
          if (i == 0) {
            mediarow1.add(aa);
          } else {
            mediarow2.add(aa);
          }
        } else if (widget.post.media.length >= 4) {
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
