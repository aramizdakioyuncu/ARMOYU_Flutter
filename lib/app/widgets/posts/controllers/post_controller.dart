import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/utils/newphotoviewer.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/likers.dart';
import 'package:ARMOYU/app/widgets/post_comments.dart';
import 'package:ARMOYU/app/widgets/shimmer/placeholder.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:video_player/video_player.dart';

class PostController extends GetxController {
  final UserAccounts currentUserAccounts;
  final Post post;

  PostController({
    required this.currentUserAccounts,
    required this.post,
  });

  var likeButtonKey = GlobalKey<LikeButtonState>().obs;

  late var likebutton = Rx<LikeButton?>(null);

  late Rx<Post> postInfo;

  @override
  void onInit() {
    super.onInit();

    // postInfo.value = post;
    postInfo = Rx<Post>(post);
    likebutton = LikeButton(
      key: likeButtonKey.value,
      isLiked: postInfo.value.isLikeme,
      likeCount: postInfo.value.likesCount,
      onTap: (isLiked) async => await postLike(isLiked),
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_outline,
          color: isLiked ? Colors.red : Colors.grey,
          size: 25,
        );
      },
    ).obs;

    if (postInfo.value.iscommentMe == true) {
      postcommentIcon.value = const Icon(Icons.comment);
      postcommentColor.value = Colors.blue;
    }

    if (postInfo.value.iscommentMe == true) {
      postrepostIcon.value = const Icon(Icons.cyclone);
      postrepostColor.value = Colors.green;
    }
  }

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }

  var controllerMessage = TextEditingController().obs;

  var likeunlikeProcces = false.obs;
  var postVisible = true.obs;

  //Comment Button
  var postcommentIcon = const Icon(Icons.comment_outlined).obs;
  var postcommentColor = Colors.grey.obs;

  //Repost Button
  var postrepostIcon = const Icon(Icons.cyclone_outlined).obs;
  var postrepostColor = Colors.grey.obs;

  var fetchCommentStatus = false.obs;
  var fetchlikersStatus = false.obs;

  Future<void> getcommentsfetch(int postID, {bool fetchRestart = false}) async {
    //Eğer önceden yüklenmişse tekrar yüklemeye çalışma
    if (!fetchRestart && postInfo.value.comments != null) {
      return;
    }

    if (fetchCommentStatus.value) {
      return;
    }
    fetchCommentStatus.value = true;

    PostCommentsFetchResponse response =
        await API.service.postsServices.commentsfetch(postID: postID);
    if (!response.result.status) {
      log(response.result.description);
      fetchCommentStatus.value = false;

      return;
    }

    //Yorumları Temizle
    postInfo.value.comments = [];

    //Veriler çek

    for (APIPostComments element in response.response!) {
      String displayname = element.postcommenter.displayname.toString();
      String avatar = element.postcommenter.avatar.minURL.toString();
      String text = element.commentContent.toString();
      bool islike = element.isLikedByMe;
      int yorumID = element.commentID;
      int userID = element.postcommenter.userID;
      int postID = element.postID;
      int commentlikescount = element.likeCount;

      Comment comment = Comment(
        commentID: yorumID,
        content: text,
        didIlike: islike,
        likeCount: commentlikescount,
        postID: postID,
        user: User(
          userID: userID,
          displayName: displayname.obs,
          avatar: Media(
            mediaID: userID,
            mediaURL: MediaURL(
              bigURL: Rx<String>(avatar),
              normalURL: Rx<String>(avatar),
              minURL: Rx<String>(avatar),
            ),
          ),
        ),
        date: "",
      );

      //Post yorumlarına ekler
      postInfo.value.comments!.add(comment);
      fetchCommentStatus.value = false;
    }

    postInfo.refresh();
  }

  Future<void> getcommentslikes(int postID, {bool fetchRestart = false}) async {
    if (!fetchRestart && postInfo.value.likers != null) {
      return;
    }

    if (fetchlikersStatus.value) {
      return;
    }
    fetchlikersStatus.value = true;

    PostLikesListResponse response =
        await API.service.postsServices.postlikeslist(postID: postID);
    if (!response.result.status) {
      log(response.result.description.toString());
      fetchlikersStatus.value = false;

      return;
    }

    //Beğenenleri Temizle
    postInfo.value.likers = [];

    for (APIPostLiker element in response.response!) {
      String displayname = element.likerdisplayname.toString();
      String avatar = element.likeravatar.minURL.toString();
      String date = element.likedate.toString();
      int userID = element.likerID;

      postInfo.value.likers!.add(
        Like(
          likeID: 1,
          user: User(
            userID: userID,
            displayName: displayname.obs,
            avatar: Media(
              mediaID: userID,
              mediaURL: MediaURL(
                bigURL: Rx<String>(avatar),
                normalURL: Rx<String>(avatar),
                minURL: Rx<String>(avatar),
              ),
            ),
          ),
          date: date,
        ),
      );
    }
    fetchlikersStatus.value = false;
  }

  Future<void> removepost() async {
    postVisible.value = false;

    PostRemoveResponse response =
        await API.service.postsServices.remove(postID: postInfo.value.postID);

    ARMOYUWidget.toastNotification(response.result.description.toString());

    if (!response.result.status) {
      postVisible.value = true;

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
      backgroundColor: Get.theme.cardColor,
      context: Get.context!,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () async => await getcommentsfetch(
              postID,
              fetchRestart: true,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CustomText.costum1(
                    SocialKeys.socialComments.tr.toUpperCase(),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Obx(
                          () => postInfo.value.comments == null
                              ? Column(
                                  children: [
                                    ShimmerPlaceholder.listTilePlaceholder(
                                      trailingIcon: const Icon(Icons.favorite),
                                    ),
                                    ShimmerPlaceholder.listTilePlaceholder(
                                      trailingIcon: const Icon(Icons.favorite),
                                    ),
                                    ShimmerPlaceholder.listTilePlaceholder(
                                      trailingIcon: const Icon(Icons.favorite),
                                    ),
                                    ShimmerPlaceholder.listTilePlaceholder(
                                      trailingIcon: const Icon(Icons.favorite),
                                    ),
                                    ShimmerPlaceholder.listTilePlaceholder(
                                      trailingIcon: const Icon(Icons.favorite),
                                    ),
                                  ],
                                )
                              : postInfo.value.comments!.isEmpty
                                  ? CustomText.costum1(
                                      SocialKeys.socialWriteFirstComment.tr)
                                  : ListView.builder(
                                      itemCount:
                                          postInfo.value.comments!.length,
                                      itemBuilder: (context, index) {
                                        return WidgetPostComments(
                                          currentUserAccounts:
                                              currentUserAccounts,
                                          comment:
                                              postInfo.value.comments![index],
                                        );
                                      },
                                    ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundImage: CachedNetworkImageProvider(
                              currentUserAccounts
                                  .user.value.avatar!.mediaURL.minURL.value,
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
                                  color: Get.theme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  controller: controllerMessage.value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: SocialKeys.socialWriteComment.tr,
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
                              PostCreateCommentResponse response =
                                  await API.service.postsServices.createcomment(
                                postID: postInfo.value.postID,
                                text: controllerMessage.value.text,
                              );
                              if (!response.result.status) {
                                ARMOYUWidget.toastNotification(
                                    response.result.description.toString());
                                return;
                              }
                              await getcommentsfetch(
                                postInfo.value.postID,
                                fetchRestart: true,
                              );
                              controllerMessage.value.text = "";
                            },
                            child: const Icon(
                              Icons.send,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return;
  }

  void aapostLike(widgetlike, postID) async {
    if (likeunlikeProcces.value) {
      return;
    }

    likeunlikeProcces.value = true;

    PostLikeResponse response =
        await API.service.postsServices.like(postID: postID);
    if (!response.result.status) {
      log(response.result.description.toString());
      widgetlike = widgetlike;
      postInfo.value.likesCount = postInfo.value.likesCount;
      return;
    }

    postInfo.value.isLikeme = true;
    postInfo.value.likesCount++;
    likeunlikeProcces.value = false;
  }

  void aa2postLike(widgetlike, postID) async {
    if (likeunlikeProcces.value) {
      return;
    }
    likeunlikeProcces.value = true;

    PostUnLikeResponse response =
        await API.service.postsServices.unlike(postID: postID);
    if (!response.result.status) {
      log(response.result.description.toString());
      widgetlike = widgetlike;
      postInfo.value.likesCount = postInfo.value.likesCount;
      return;
    }

    postInfo.value.isLikeme = false;
    postInfo.value.likesCount--;

    likeunlikeProcces.value = false;
  }

  Future<bool> postLike(bool isLiked) async {
    if (isLiked) {
      if (likeunlikeProcces.value) {
        return isLiked;
      }
      //Beğenmeme fonksiyonu
      aa2postLike(postInfo.value.isLikeme, postInfo.value.postID);
    } else {
      aapostLike(postInfo.value.isLikeme, postInfo.value.postID);
    }
    return !isLiked;
  }

  void postcommentlikeslist() {
    //Yorumları Çekmeye başla
    getcommentslikes(postInfo.value.postID);

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.cardColor,
      context: Get.context!,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () => getcommentslikes(
              postInfo.value.postID,
              fetchRestart: true,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    SocialKeys.socialLikers.tr.toUpperCase(),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Obx(
                          () => postInfo.value.likers == null
                              ? Column(
                                  children: [
                                    ShimmerPlaceholder.listTilePlaceholder(),
                                    ShimmerPlaceholder.listTilePlaceholder(),
                                    ShimmerPlaceholder.listTilePlaceholder(),
                                    ShimmerPlaceholder.listTilePlaceholder(),
                                    ShimmerPlaceholder.listTilePlaceholder(),
                                    ShimmerPlaceholder.listTilePlaceholder(),
                                  ],
                                )
                              : postInfo.value.likers!.isEmpty
                                  ? CustomText.costum1(CommonKeys.empty.tr)
                                  : ListView.builder(
                                      itemCount: postInfo.value.likers!.length,
                                      itemBuilder: (context, index) {
                                        return LikersListWidget(
                                          currentUserAccounts:
                                              currentUserAccounts,
                                          date: postInfo
                                              .value.likers![index].date,
                                          islike: 1,
                                          user: postInfo
                                              .value.likers![index].user,
                                        );
                                      },
                                    ),
                        ),
                      ),
                    ),
                  ),
                ],
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
      backgroundColor: Get.theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: Get.context!,
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
                        PostRemoveResponse response = await API
                            .service.postsServices
                            .remove(postID: postInfo.value.postID);
                        if (!response.result.status) {
                          log(response.result.description);
                          return;
                        }
                        log(response.result.description);
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.star_rate_sharp,
                        ),
                        title: Text(SocialKeys.socialAddFavorite.tr),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: postInfo.value.owner.userID ==
                        currentUserAccounts.user.value.userID,
                    child: InkWell(
                      onTap: () async {},
                      child: ListTile(
                        leading: const Icon(
                          Icons.edit_note_sharp,
                        ),
                        title: Text(SocialKeys.socialedit.tr),
                      ),
                    ),
                  ),
                  const Visibility(
                    //Çizgi ekler
                    child: Divider(),
                  ),
                  Visibility(
                    visible: postInfo.value.owner.userID !=
                        currentUserAccounts.user.value.userID,
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        textColor: Colors.red,
                        leading: const Icon(
                          Icons.flag,
                          color: Colors.red,
                        ),
                        title: Text(SocialKeys.socialReport.tr),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: postInfo.value.owner.userID !=
                        currentUserAccounts.user.value.userID,
                    child: InkWell(
                      onTap: () async {
                        Get.back();

                        BlockingAddResponse response = await API
                            .service.blockingServices
                            .add(userID: postInfo.value.owner.userID!);

                        ARMOYUWidget.toastNotification(
                          response.result.description,
                        );
                      },
                      child: ListTile(
                        textColor: Colors.red,
                        leading: const Icon(
                          Icons.person_off_outlined,
                          color: Colors.red,
                        ),
                        title: Text(SocialKeys.socialBlock.tr),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: postInfo.value.owner.userID ==
                        currentUserAccounts.user.value.userID,
                    child: InkWell(
                      onTap: () async => ARMOYUWidget.showConfirmationDialog(
                        context,
                        accept: removepost,
                      ),
                      child: ListTile(
                        textColor: Colors.red,
                        leading: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(SocialKeys.socialdelete.tr),
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

  Widget buildMediaContent(BuildContext context) {
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

    if (postInfo.value.media.isNotEmpty) {
      List<Row> mediaItems = [];

      List<Widget> mediarow1 = [];
      List<Widget> mediarow2 = [];
      for (int i = 0; i < postInfo.value.media.length; i++) {
        if (i > 3) {
          continue;
        }

        List media = postInfo.value.media[i].mediaType!.split('/');

        if (media[0] == "video") {
          mediarow1.clear();
          mediarow1.add(
            mediaSablon(
              indexlength: postInfo.value.media.length,
              postInfo.value.media[i].mediaURL.normalURL.value,
              isvideo: true,
            ),
          );
          break;
        }

        BoxFit mediadirection = BoxFit.cover;
        if (postInfo.value.media[i].mediaDirection.toString() == "yatay" &&
            postInfo.value.media.length == 1) {
          mediadirection = BoxFit.contain;
        }

        double mediawidth = ARMOYU.screenWidth;
        double mediaheight = ARMOYU.screenHeight;
        if (postInfo.value.media.length == 1) {
          mediawidth = mediawidth / 1;

          mediaheight = mediaheight / 2;
        } else if (postInfo.value.media.length == 2) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        } else if (postInfo.value.media.length == 3) {
          if (i == 0) {
            mediawidth = mediawidth / 1;
            mediaheight = mediaheight / 2.5;
          } else {
            mediawidth = mediawidth / 2;
            mediaheight = mediaheight / 4;
          }
        } else if (postInfo.value.media.length >= 4) {
          mediawidth = mediawidth / 2;
          mediaheight = mediaheight / 4;
        }

        GestureDetector aa = GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MediaViewer(
                  currentUser: currentUserAccounts.user.value,
                  media: postInfo.value.media,
                  initialIndex: i,
                ),
              ),
            );
          },
          child: mediaSablon(
            indexlength: postInfo.value.media.length,
            postInfo.value.media[i].mediaURL.normalURL.value,
            width: mediawidth,
            height: mediaheight,
            fit: mediadirection,
            islastmedia: i == 3,
          ),
        );

        if (postInfo.value.media.length == 3) {
          if (i == 0) {
            mediarow1.add(aa);
          } else {
            mediarow2.add(aa);
          }
        } else if (postInfo.value.media.length >= 4) {
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
