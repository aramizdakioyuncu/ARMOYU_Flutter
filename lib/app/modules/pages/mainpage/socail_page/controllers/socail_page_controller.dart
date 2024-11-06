import 'dart:developer';

import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/Social/like.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/Story/story.dart';
import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/functions/API_Functions/posts.dart';
import 'package:ARMOYU/app/functions/API_Functions/story.dart';
import 'package:ARMOYU/app/modules/pages/mainpage/_main/controllers/main_controller.dart';
import 'package:ARMOYU/app/widgets/Skeletons/cards_skeleton.dart';
import 'package:ARMOYU/app/widgets/Skeletons/posts_skeleton.dart';
import 'package:ARMOYU/app/widgets/Skeletons/storycircle_skeleton.dart';
import 'package:ARMOYU/app/widgets/posts/views/post_view.dart';
import 'package:ARMOYU/app/widgets/storycircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocailPageController extends GetxController {
  final UserAccounts currentUserAccounts;
  final ScrollController scrollController;

  SocailPageController({
    required this.currentUserAccounts,
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

  @override
  void onInit() {
    super.onInit();

    final mainController = Get.find<MainPageController>(
      tag: currentUserAccounts.user.userID.toString(),
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
      if (currentUserAccounts.user.widgetPosts != null) {
        widgetstoryUpdate();
      } else {
        loadSkeletonpost(story: true);
      }
    }

    fetchStoryStatus.value = true;

    FunctionsStory f = FunctionsStory(currentUser: currentUserAccounts.user);
    Map<String, dynamic> response = await f.stories(storypage.value);
    if (response["durum"] == 0) {
      log(response["aciklama"]);

      fetchStoryStatus.value = false;
      return;
    }

    if (storypage.value == 1) {
      currentUserAccounts.user.widgetStoriescard = [];
      if (response["icerik"].length == 0) {
        currentUserAccounts.user.widgetStoriescard!.add(
          StoryList(
            owner: User(
              userID: currentUserAccounts.user.userID,
              userName: "Hikayen",
              avatar: currentUserAccounts.user.avatar,
            ),
            story: null,
            isView: true,
          ),
        );
      }
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Story> widgetStory = [];

      if (storypage.value == 1) {
        if (i == 0) {
          if (response["icerik"][i]["oyuncu_ID"].toString() !=
              currentUserAccounts.user.userID.toString()) {
            currentUserAccounts.user.widgetStoriescard!.add(
              StoryList(
                owner: User(
                  userID: currentUserAccounts.user.userID,
                  userName: "Hikayen",
                  avatar: currentUserAccounts.user.avatar,
                ),
                story: null,
                isView: true,
              ),
            );
          }
        }
      }

      int toplamgoruntulenmesayisi = 0;
      for (var j = 0; j < response["icerik"][i]["hikaye_icerik"].length; j++) {
        if (response["icerik"][i]["hikaye_icerik"][j]
                ["hikaye_bengoruntulenme"] ==
            1) {
          toplamgoruntulenmesayisi++;
        }
        widgetStory.add(
          Story(
            storyID: response["icerik"][i]["hikaye_icerik"][j]["hikaye_ID"],
            ownerID: response["icerik"][i]["oyuncu_ID"],
            ownerusername: response["icerik"][i]["oyuncu_kadi"],
            owneravatar: response["icerik"][i]["oyuncu_avatar"],
            time: response["icerik"][i]["hikaye_icerik"][j]["hikaye_zaman"],
            media: response["icerik"][i]["hikaye_icerik"][j]["hikaye_medya"],
            isLike: response["icerik"][i]["hikaye_icerik"][j]
                ["hikaye_benbegeni"],
            isView: response["icerik"][i]["hikaye_icerik"][j]
                ["hikaye_bengoruntulenme"],
          ),
        );
      }
      bool viewstory = false;
      if (toplamgoruntulenmesayisi ==
          response["icerik"][i]["hikaye_icerik"].length) {
        viewstory = true;
      }

      currentUserAccounts.user.widgetStoriescard!.add(
        StoryList(
          owner: User(
            userID: response["icerik"][i]["oyuncu_ID"],
            userName: response["icerik"][i]["oyuncu_kadi"],
            avatar: Media(
              mediaID: response["icerik"][i]["oyuncu_ID"],
              mediaURL: MediaURL(
                bigURL: response["icerik"][i]["oyuncu_avatar"],
                normalURL: response["icerik"][i]["oyuncu_avatar"],
                minURL: response["icerik"][i]["oyuncu_avatar"],
              ),
            ),
          ),
          story: widgetStory,
          isView: viewstory,
        ),
      );
    }
    widgetstoryUpdate();

    fetchStoryStatus.value = false;
  }

  Future<void> fetchPosts({bool fetchRestart = false}) async {
    if (fetchPostStatus.value) {
      return;
    }
    if (fetchRestart) {
      postpage.value = 1;

      if (currentUserAccounts.user.widgetPosts != null) {
        widgetpostUpdate(currentUserAccounts.user.widgetPosts!);
      } else {
        loadSkeletonpost(posts: true);
      }
    }

    fetchPostStatus.value = true;

    FunctionsPosts f = FunctionsPosts(currentUser: currentUserAccounts.user);
    Map<String, dynamic> response = await f.getPosts(postpage.value);
    if (response["durum"] == 0) {
      log(response["aciklama"]);

      fetchPostStatus.value = false;
      return;
    }

    if (postpage.value == 1) {
      widgetPosts.value = [];
      currentUserAccounts.user.widgetPosts = [];
    }

    List<Post> cachedPostlist = [];
    for (int i = 0; i < response["icerik"].length; i++) {
      List<Media> media = [];
      List<Comment> comments = [];
      List<Like> likers = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        for (var mediaInfo in response["icerik"][i]["paylasimfoto"]) {
          media.add(
            Media(
              mediaID: mediaInfo["fotoID"],
              ownerID: response["icerik"][i]["sahipID"],
              mediaType: mediaInfo["paylasimkategori"],
              mediaDirection: mediaInfo["medyayonu"],
              mediaURL: MediaURL(
                bigURL: Rx<String>(mediaInfo["fotourl"]),
                normalURL: Rx<String>(mediaInfo["fotoufakurl"]),
                minURL: Rx<String>(mediaInfo["fotominnakurl"]),
              ),
            ),
          );
        }
      }
      for (var firstthreelike in response["icerik"][i]
          ["paylasimilkucbegenen"]) {
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
                    bigURL: Rx<String>(firstthreelike["avatar"]),
                    normalURL: Rx<String>(firstthreelike["avatar"]),
                    minURL: Rx<String>(firstthreelike["avatar"]),
                  ),
                ),
              ),
              date: firstthreelike["begeni_zaman"]),
        );
      }
      for (var firstthreecomment in response["icerik"][i]["ilkucyorum"]) {
        comments.add(
          Comment(
              commentID: firstthreecomment["yorumID"],
              postID: firstthreecomment["paylasimID"],
              user: User(
                userID: firstthreecomment["yorumcuid"],
                displayName: firstthreecomment["yorumcuadsoyad"],
                userName: firstthreecomment["yorumcukullaniciad"],
                avatar: Media(
                  mediaID: firstthreecomment["yorumcuid"],
                  mediaURL: MediaURL(
                    bigURL: Rx<String>(firstthreecomment["yorumcuavatar"]),
                    normalURL:
                        Rx<String>(firstthreecomment["yorumcuufakavatar"]),
                    minURL:
                        Rx<String>(firstthreecomment["yorumcuminnakavatar"]),
                  ),
                ),
              ),
              content: firstthreecomment["yorumcuicerik"],
              likeCount: firstthreecomment["yorumbegenisayi"],
              didIlike: firstthreecomment["benbegendim"] == 1 ? true : false,
              date: firstthreecomment["yorumcuzamangecen"]),
        );
      }

      bool ismelike = false;
      if (response["icerik"][i]["benbegendim"] == 1) {
        ismelike = true;
      } else {
        ismelike = false;
      }
      bool ismecomment = false;

      if (response["icerik"][i]["benyorumladim"] == 1) {
        ismecomment = true;
      } else {
        ismecomment = false;
      }
      Post post = Post(
        postID: response["icerik"][i]["paylasimID"],
        content: response["icerik"][i]["paylasimicerik"],
        postDate: response["icerik"][i]["paylasimzamangecen"],
        sharedDevice: response["icerik"][i]["paylasimnereden"],
        likesCount: response["icerik"][i]["begenisay"],
        isLikeme: ismelike,
        commentsCount: response["icerik"][i]["yorumsay"],
        iscommentMe: ismecomment,
        media: media,
        owner: User(
          userID: response["icerik"][i]["sahipID"],
          userName: response["icerik"][i]["sahipad"],
          avatar: Media(
            mediaID: response["icerik"][i]["sahipID"],
            mediaURL: MediaURL(
              bigURL: Rx<String>(response["icerik"][i]["sahipavatarminnak"]),
              normalURL: Rx<String>(response["icerik"][i]["sahipavatarminnak"]),
              minURL: Rx<String>(response["icerik"][i]["sahipavatarminnak"]),
            ),
          ),
        ),
        firstthreecomment: comments,
        firstthreelike: likers,
        location: response["icerik"][i]["paylasimkonum"],
      );

      cachedPostlist.add(post);
      currentUserAccounts.user.widgetPosts!.add(post);
    }
    widgetpostUpdate(cachedPostlist);

    fetchPostStatus.value = false;
    postpage++;
  }

  void widgetstoryUpdate() {
    if (currentUserAccounts.user.widgetStoriescard == null) {
      return;
    }
    widgetStories.value = WidgetStorycircle(
      currentUser: currentUserAccounts.user,
      content: currentUserAccounts.user.widgetStoriescard!,
    );
  }

  void widgetpostUpdate(List<Post> list) {
    int counter = 0;
    for (Post postsInfo in list) {
      counter++;

      //Postu ekle
      widgetPosts.add(
        TwitterPostWidget(
          currentUserAccounts: currentUserAccounts,
          post: postsInfo,
        ),
      );

      //Popülerlik Kartını ekle
      if (counter / 3 == 1 || counter / 12 == 1) {
        widgetPosts.add(
          ARMOYUWidget(
            currentUserAccounts: currentUserAccounts,
            scrollController: ScrollController(),
            content: listPOPCard,
            firstFetch: listPOPCard.isEmpty,
          ).widgetPOPlist(),
        );
      }

      //TP Kartını ekle
      if (counter / 8 == 1 || counter / 17 == 1) {
        widgetPosts.add(
          ARMOYUWidget(
            currentUserAccounts: currentUserAccounts,
            scrollController: ScrollController(),
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
      widgetStories.value =
          SkeletonStorycircle(currentUser: currentUserAccounts.user, count: 11);
    }

    if (posts) {
      currentUserAccounts.user.widgetPosts = [];
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
