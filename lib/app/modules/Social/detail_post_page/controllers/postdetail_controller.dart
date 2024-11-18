import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/services/API/posts_api.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/post_comments.dart';
import 'package:ARMOYU/app/widgets/posts/views/post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PostdetailController extends GetxController {
  var commentheight = Rx<double>(0);
  var controllerMessage = TextEditingController().obs;
  var listComments = <Widget>[].obs;

  Future<void> getcommentsfetch(int postID, List<Widget> listComments) async {
    listComments.clear();
    listComments.add(
      const CupertinoActivityIndicator(),
    );

    PostsAPI funct =
        PostsAPI(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response = await funct.commentsfetch(postID: postID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    listComments.clear();

    for (int i = 0; i < response["icerik"].length; i++) {
      String displayname = response["icerik"][i]["yorumcuadsoyad"].toString();
      String avatar = response["icerik"][i]["yorumcuminnakavatar"].toString();
      String text = response["icerik"][i]["yorumcuicerik"].toString();
      int islike = response["icerik"][i]["benbegendim"];
      int yorumID = response["icerik"][i]["yorumID"];
      int userID = response["icerik"][i]["yorumcuid"];
      int postID = response["icerik"][i]["paylasimID"];
      int commentlikescount = response["icerik"][i]["yorumbegenisayi"];

      listComments.add(
        WidgetPostComments(
          currentUserAccounts: currentUserAccounts.value,
          comment: Comment(
            commentID: yorumID,
            content: text,
            didIlike: islike == 1 ? true : false,
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
    PostsAPI funct =
        PostsAPI(currentUser: currentUserAccounts.value.user.value);
    Map<String, dynamic> response = await funct.detailfetch(
      postID: postID.value,
      category: "yorum",
      categoryDetail: commentID.value,
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
              bigURL: Rx<String>(
                  response["icerik"][0]["paylasimfoto"][j]["fotourl"]),
              normalURL: Rx<String>(
                  response["icerik"][0]["paylasimfoto"][j]["fotoufakurl"]),
              minURL: Rx<String>(
                  response["icerik"][0]["paylasimfoto"][j]["fotominnakurl"]),
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
              displayName: Rx<String>(firstthreelike["adsoyad"]),
              userName: Rx<String>(firstthreelike["kullaniciadi"]),
              avatar: Media(
                mediaID: firstthreelike["ID"],
                mediaURL: MediaURL(
                  bigURL: Rx<String>(firstthreelike["avatar"]),
                  normalURL: Rx<String>(firstthreelike["avatar"]),
                  minURL: Rx<String>(firstthreelike["avatar"]),
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
              displayName: Rx<String>(firstthreecomment["yorumcuadsoyad"]),
              avatar: Media(
                mediaID: firstthreecomment["yorumcuid"],
                mediaURL: MediaURL(
                  bigURL: Rx<String>(firstthreecomment["yorumcuavatar"]),
                  normalURL: Rx<String>(firstthreecomment["yorumcuufakavatar"]),
                  minURL: Rx<String>(firstthreecomment["yorumcuminnakavatar"]),
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
        userName: Rx<String>(response["icerik"][0]["sahipad"]),
        avatar: Media(
          mediaID: response["icerik"][0]["sahipID"],
          mediaURL: MediaURL(
            bigURL: Rx<String>(response["icerik"][0]["sahipavatarminnak"]),
            normalURL: Rx<String>(response["icerik"][0]["sahipavatarminnak"]),
            minURL: Rx<String>(response["icerik"][0]["sahipavatarminnak"]),
          ),
        ),
      ),
      firstthreecomment: comments,
      firstthreelike: likers,
      location: response["icerik"][0]["paylasimkonum"],
    );
    widget.value = TwitterPostWidget(
      currentUserAccounts: currentUserAccounts.value,
      post: post,
    );
  }

  var currentUserAccounts = Rx<UserAccounts>(UserAccounts(user: User().obs));
  var postID = Rx<int?>(null);
  var commentID = Rx<int?>(null);
  @override
  void onInit() {
    super.onInit();
    //* *//
    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;
    //* *//

    Map<String, dynamic> arguments = Get.arguments;
    postID.value = arguments['postID'];
    commentID.value = arguments['commentID'];
    log(commentID.value.toString());
    postdetailfetch();
  }
}
