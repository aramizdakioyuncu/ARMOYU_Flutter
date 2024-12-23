import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/armoyu.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/post_comments/post_comments_view.dart';
import 'package:ARMOYU/app/widgets/posts/views/post_view.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart' as armoyumedia;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PostdetailController extends GetxController {
  var commentheight = Rx<double>(0);
  var controllerMessage = TextEditingController().obs;
  var listComments = <Widget>[].obs;

  // var currentUserAccounts =
  //     Rx<UserAccounts>(UserAccounts(user: User().obs, sessionTOKEN: Rx("")));
  var postID = Rx<int?>(null);
  var commentID = Rx<int?>(null);
  @override
  void onInit() {
    super.onInit();
    //* *//
    // final findCurrentAccountController = Get.find<AccountUserController>();
    // currentUserAccounts.value =
    //     findCurrentAccountController.currentUserAccounts.value;
    //* *//

    Map<String, dynamic> arguments = Get.arguments;
    postID.value = arguments['postID'];
    commentID.value = arguments['commentID'];
    log(commentID.value.toString());
    postdetailfetch();
  }

  Future<void> getcommentsfetch(int postID, List listComments) async {
    listComments.clear();
    listComments.add(
      const CupertinoActivityIndicator(),
    );

    PostCommentsFetchResponse response =
        await API.service.postsServices.commentsfetch(postID: postID);
    if (!response.result.status) {
      log(response.result.description);
      return;
    }
    listComments.clear();

    for (var element in response.response!) {
      String displayname = element.postcommenter.displayname.toString();
      String avatar = element.postcommenter.avatar.toString();
      String text = element.commentContent.toString();
      bool islike = element.isLikedByMe;
      int yorumID = element.commentID;
      int userID = element.postcommenter.userID;
      int postID = element.postID;
      int commentlikescount = element.likeCount;

      listComments.add(
        Comment(
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
        ),
      );
    }

    if (listComments.length >= 6) {
      commentheight.value = ARMOYU.screenHeight * 0.6;
    } else if (listComments.length >= 4) {
      commentheight.value = ARMOYU.screenHeight * 0.4;
    } else {
      commentheight.value = ARMOYU.screenHeight * 0.2;
    }
  }

  var widget = Rx<Widget?>(null);
  Future<void> postdetailfetch() async {
    PostFetchResponse response = await API.service.postsServices.detailfetch(
      postID: postID.value,
      category: "yorum",
      categoryDetail: commentID.value,
    );
    if (!response.result.status) {
      log(response.result.description);
      return;
    }

    List<Media> media = [];
    RxList<Comment> comments = RxList<Comment>([]);
    RxList<Like>? likers = RxList<Like>([]);

    getcommentsfetch(response.response!.postID, listComments);

    if (response.response!.media!.isNotEmpty) {
      for (armoyumedia.Media element in response.response!.media!) {
        media.add(
          Media(
            mediaID: element.mediaID,
            ownerID: element.owner!.userID,
            mediaType: element.mediaType,
            mediaDirection: element.mediaDirection,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.mediaURL.bigURL),
              normalURL: Rx<String>(element.mediaURL.normalURL),
              minURL: Rx<String>(element.mediaURL.minURL),
            ),
          ),
        );
      }
    }

    for (APIPostLiker firstthreelike in response.response!.firstlikers!) {
      likers.add(
        Like(
          likeID: firstthreelike.postlikeID,
          user: User(
            userID: firstthreelike.likerID,
            displayName: Rx<String>(firstthreelike.likerdisplayname),
            userName: Rx<String>(firstthreelike.likerusername),
            avatar: Media(
              mediaID: firstthreelike.likerID,
              mediaURL: MediaURL(
                bigURL: Rx<String>(firstthreelike.likeravatar.bigURL),
                normalURL: Rx<String>(firstthreelike.likeravatar.normalURL),
                minURL: Rx<String>(firstthreelike.likeravatar.minURL),
              ),
            ),
          ),
          date: firstthreelike.likedate,
        ),
      );
    }

    for (APIPostComments firstthreecomment
        in response.response!.firstcomments!) {
      comments.add(
        Comment(
          commentID: firstthreecomment.commentID,
          postID: firstthreecomment.postID,
          user: User(
            userID: firstthreecomment.postcommenter.userID,
            displayName:
                Rx<String>(firstthreecomment.postcommenter.displayname),
            avatar: Media(
              mediaID: firstthreecomment.postcommenter.userID,
              mediaURL: MediaURL(
                bigURL:
                    Rx<String>(firstthreecomment.postcommenter.avatar.bigURL),
                normalURL: Rx<String>(
                    firstthreecomment.postcommenter.avatar.normalURL),
                minURL:
                    Rx<String>(firstthreecomment.postcommenter.avatar.minURL),
              ),
            ),
          ),
          content: firstthreecomment.commentContent,
          likeCount: firstthreecomment.likeCount,
          didIlike: firstthreecomment.isLikedByMe ? true : false,
          date: firstthreecomment.commentTime,
        ),
      );
    }
    Post post = Post(
      postID: response.response!.postID,
      content: response.response!.content,
      postDate: response.response!.date,
      sharedDevice: response.response!.postdevice,
      likesCount: response.response!.likeCount,
      isLikeme: response.response!.likeCount == 1 ? true : false,
      commentsCount: response.response!.commentCount,
      iscommentMe: response.response!.didicommentit == 1 ? true : false,
      media: media,
      owner: User(
        userID: response.response!.postOwner.ownerID,
        userName: Rx<String>(response.response!.postOwner.displayName),
        avatar: Media(
          mediaID: response.response!.postOwner.ownerID,
          mediaURL: MediaURL(
            bigURL: Rx<String>(response.response!.postOwner.avatar.bigURL),
            normalURL:
                Rx<String>(response.response!.postOwner.avatar.normalURL),
            minURL: Rx<String>(response.response!.postOwner.avatar.minURL),
          ),
        ),
      ),
      firstthreecomment: comments,
      firstthreelike: likers,
      location: response.response!.location,
    );
    widget.value = TwitterPostWidget(
      post: post,
    );
  }
}
