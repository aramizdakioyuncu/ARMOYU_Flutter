import 'dart:developer';

import 'package:ARMOYU/app/core/api.dart';
import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/Story/story.dart';
import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/Skeletons/cards_skeleton.dart';
import 'package:ARMOYU/app/widgets/Skeletons/posts_skeleton.dart';
import 'package:ARMOYU/app/widgets/Skeletons/storycircle_skeleton.dart';
import 'package:ARMOYU/app/widgets/posts/views/post_view.dart';
import 'package:ARMOYU/app/widgets/storycircle.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/post/post_detail.dart';
import 'package:armoyu_services/core/models/ARMOYU/API/story/story_list.dart';
import 'package:armoyu_services/core/models/ARMOYU/_response/response.dart';
import 'package:armoyu_services/core/models/ARMOYU/media.dart' as armoyumedia;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocailPageController extends GetxController {
  final ScrollController scrollController;

  SocailPageController({
    required this.scrollController,
  });

  late final ScrollController _scrollController;

  var listTPCard = <Map<String, String>>[].obs; // Reaktif liste
  var listPOPCard = <Map<String, String>>[].obs; // Reaktif liste

  var fetchPostStatus = false.obs;
  var postpage = 1.obs;

  var fetchStoryStatus = false.obs;
  var storypage = 1.obs;

  var widgetPosts = <Widget>[].obs;

  var widgetStories = Rx<Widget?>(null);

  var currentUserAccounts = Rx<UserAccounts>(
    UserAccounts(
      user: User().obs,
      sessionTOKEN: Rx(""),
      language: Rx(""),
    ),
  );

  @override
  void onInit() {
    super.onInit();

    final findCurrentAccountController = Get.find<AccountUserController>();
    currentUserAccounts.value =
        findCurrentAccountController.currentUserAccounts.value;

    final mainController = Get.find<MainPageController>(
      tag: currentUserAccounts.value.user.value.userID.toString(),
    );

    _scrollController = mainController.homepageScrollControllerv2.value;

    // _scrollController = scrollController;

    loadPosts(fetchRestart: true);
    loadStories(fetchRestart: true);

    // ScrollController'ı dinle
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        loadMoreData();
      }
    });
  }

  //Sayfa Yenilenme işlemi
  Future<void> handleRefresh() async {
    loadStories(fetchRestart: true);
    await loadPosts(fetchRestart: true);
  }

  // Yeni veri yükleme işlemi
  Future<void> loadMoreData() async {
    await loadPosts();
  }

  //Hikaye Fonksiyon
  Future<void> fetchstoryWidget({bool fetchRestart = false}) async {
    if (fetchStoryStatus.value) {
      return;
    }

    if (fetchRestart) {
      if (currentUserAccounts.value.user.value.widgetPosts != null) {
        widgetstoryUpdate();
      } else {
        loadSkeletonpost(story: true);
      }
    }

    fetchStoryStatus.value = true;

    StoryFetchListResponse response =
        await API.service.storyServices.stories(page: storypage.value);

    if (!response.result.status) {
      log(response.result.description);
      fetchStoryStatus.value = false;
      return;
    }
    log("Hikaye Sayısı ${response.response!.length}");

    if (storypage.value == 1) {
      currentUserAccounts.value.user.value.widgetStoriescard =
          <StoryList>[].obs;

      if (response.response!.isEmpty) {
        currentUserAccounts.value.user.value.widgetStoriescard!.add(
          StoryList(
            owner: User(
              userID: currentUserAccounts.value.user.value.userID,
              userName: (SocialKeys.socialStory.tr).obs,
              avatar: currentUserAccounts.value.user.value.avatar,
            ),
            story: null,
            isView: true,
          ),
        );
      }
    }

    int sirasay = -1;
    for (APIStoryList element in response.response!) {
      log("Hikaye ${element.oyuncuAdSoyad}");

      sirasay++;
      List<Story> widgetStory = [];

      if (storypage.value == 1) {
        if (sirasay == 0) {
          if (element.oyuncuId.toString() !=
              currentUserAccounts.value.user.value.userID.toString()) {
            currentUserAccounts.value.user.value.widgetStoriescard!.add(
              StoryList(
                owner: User(
                  userID: currentUserAccounts.value.user.value.userID,
                  userName: (SocialKeys.socialStory.tr).obs,
                  avatar: currentUserAccounts.value.user.value.avatar,
                ),
                story: null,
                isView: true,
              ),
            );
          }
        }
      }

      int toplamgoruntulenmesayisi = 0;

      for (var element2 in element.hikayeIcerik) {
        if (element2.hikayeBenGoruntulenme == 1) {
          toplamgoruntulenmesayisi++;
        }
        widgetStory.add(
          Story(
            storyID: element2.hikayeId,
            ownerID: element2.hikayeSahip,
            ownerusername: element.oyuncuKadi,
            owneravatar: element.oyuncuAvatar.minURL,
            time: element2.hikayeZaman,
            media: element2.hikayeMedya,
            isLike: element2.hikayeBenBegeni,
            isView: element2.hikayeBenGoruntulenme,
          ),
        );
      }
      bool viewstory = false;
      if (toplamgoruntulenmesayisi == element.hikayeIcerik.length) {
        viewstory = true;
      }

      currentUserAccounts.value.user.value.widgetStoriescard!.add(
        StoryList(
          owner: User(
            userID: element.oyuncuId,
            userName: Rx<String>(element.oyuncuKadi),
            avatar: Media(
              mediaID: element.oyuncuId,
              mediaURL: MediaURL(
                bigURL: Rx<String>(element.oyuncuAvatar.bigURL),
                normalURL: Rx<String>(element.oyuncuAvatar.normalURL),
                minURL: Rx<String>(element.oyuncuAvatar.minURL),
              ),
            ),
          ),
          story: widgetStory,
          isView: viewstory,
        ),
      );
    }
    currentUserAccounts.value.user.value.widgetStoriescard!.refresh();
    widgetstoryUpdate();

    fetchStoryStatus.value = false;
  }

  Future<void> fetchPosts({bool fetchRestart = false}) async {
    if (fetchPostStatus.value) {
      return;
    }
    if (fetchRestart) {
      postpage.value = 1;

      if (currentUserAccounts.value.user.value.widgetPosts != null) {
        widgetpostUpdate(currentUserAccounts.value.user.value.widgetPosts!);
      } else {
        loadSkeletonpost(posts: true);
      }
    }

    fetchPostStatus.value = true;

    PostFetchListResponse response =
        await API.service.postsServices.getPosts(page: postpage.value);
    if (!response.result.status) {
      log(response.result.description);

      fetchPostStatus.value = false;
      return;
    }

    if (postpage.value == 1) {
      widgetPosts.value = [];
      currentUserAccounts.value.user.value.widgetPosts = <Post>[].obs;
    }

    List<Post> cachedPostlist = [];

    for (APIPostList element in response.response!) {
      List<Media>? media = [];
      RxList<Comment> comments = RxList<Comment>([]);
      RxList<Like>? likers = RxList<Like>([]);

      if (element.media!.isNotEmpty) {
        for (armoyumedia.Media mediaInfo in element.media!) {
          media.add(
            Media(
              mediaID: mediaInfo.mediaID,
              ownerID: element.postOwner.ownerID,
              mediaType: mediaInfo.mediaType,
              mediaDirection: mediaInfo.mediaDirection,
              mediaURL: MediaURL(
                bigURL: Rx<String>(mediaInfo.mediaURL.bigURL),
                normalURL: Rx<String>(mediaInfo.mediaURL.normalURL),
                minURL: Rx<String>(mediaInfo.mediaURL.minURL),
              ),
            ),
          );
        }
      }
      for (APIPostLiker firstthreelike in element.firstlikers!) {
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

      for (APIPostComments firstthreecomment in element.firstcomments!) {
        comments.add(
          Comment(
            commentID: firstthreecomment.commentID,
            postID: firstthreecomment.postID,
            user: User(
              userID: firstthreecomment.postcommenter.userID,
              displayName:
                  Rx<String>(firstthreecomment.postcommenter.displayname),
              userName: Rx<String>(firstthreecomment.postcommenter.username),
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

      bool ismelike = false;
      if (element.didilikeit == 1) {
        ismelike = true;
      } else {
        ismelike = false;
      }
      bool ismecomment = false;

      if (element.didicommentit == 1) {
        ismecomment = true;
      } else {
        ismecomment = false;
      }
      Post post = Post(
        postID: element.postID,
        content: element.content,
        postDate: element.datecounting,
        sharedDevice: element.postdevice,
        likesCount: element.likeCount,
        isLikeme: ismelike,
        commentsCount: element.commentCount,
        iscommentMe: ismecomment,
        media: media,
        owner: User(
          userID: element.postOwner.ownerID,
          userName: Rx<String>(element.postOwner.displayName),
          avatar: Media(
            mediaID: element.postOwner.ownerID,
            mediaURL: MediaURL(
              bigURL: Rx<String>(element.postOwner.avatar.bigURL),
              normalURL: Rx<String>(element.postOwner.avatar.normalURL),
              minURL: Rx<String>(element.postOwner.avatar.minURL),
            ),
          ),
        ),
        firstthreecomment: comments,
        firstthreelike: likers,
        location: element.location,
      );

      cachedPostlist.add(post);
      currentUserAccounts.value.user.value.widgetPosts!.add(post);
    }
    currentUserAccounts.value.user.value.widgetPosts!.refresh();

    widgetpostUpdate(cachedPostlist);

    fetchPostStatus.value = false;
    postpage++;
  }

  void widgetstoryUpdate() {
    if (currentUserAccounts.value.user.value.widgetStoriescard == null) {
      return;
    }
    widgetStories.value = WidgetStorycircle(
      content: currentUserAccounts.value.user.value.widgetStoriescard!,
    );
  }

  void widgetpostUpdate(List<Post> list) {
    int counter = 0;
    for (Post postsInfo in list) {
      counter++;

      //Postu ekle
      widgetPosts.add(
        TwitterPostWidget(post: postsInfo),
      );

      //Popülerlik Kartını ekle
      if (counter / 3 == 1 || counter / 12 == 1) {
        widgetPosts.add(
          ARMOYUWidget(
            content: listPOPCard,
            firstFetch: listPOPCard.isEmpty,
          ).widgetPOPlist(),
        );
      }

      //TP Kartını ekle
      if (counter / 8 == 1 || counter / 17 == 1) {
        widgetPosts.add(
          ARMOYUWidget(
            content: listTPCard,
            firstFetch: listTPCard.isEmpty,
          ).widgetTPlist(),
        );
      }
    }
  }

  Future<void> loadSkeletonpost(
      {bool story = false, bool posts = false}) async {
    if (story) {
      widgetStories.value = SkeletonStorycircle(
          currentUser: currentUserAccounts.value.user.value, count: 11);
    }

    if (posts) {
      currentUserAccounts.value.user.value.widgetPosts = <Post>[].obs;
      widgetPosts.value = [];

      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(
        const SkeletonCustomCards(
          count: 5,
          icon: Icon(
            Icons.view_comfortable_sharp,
          ),
        ),
      );
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      currentUserAccounts.value.user.value.widgetPosts!.refresh();
    }
  }

  Future<void> loadStories({bool fetchRestart = false}) async {
    if (fetchRestart) {
      storypage.value = 1;
    }
    await fetchstoryWidget(fetchRestart: fetchRestart);
  }

  Future<void> loadPosts({bool fetchRestart = false}) async {
    if (fetchRestart) {
      postpage.value = 1;
    }

    await fetchPosts(fetchRestart: fetchRestart);
  }
}
