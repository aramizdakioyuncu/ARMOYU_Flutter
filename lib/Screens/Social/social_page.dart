import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/story.dart';
import 'package:ARMOYU/Models/Social/comment.dart';
import 'package:ARMOYU/Models/Social/like.dart';
import 'package:ARMOYU/Models/Story/story.dart';
import 'package:ARMOYU/Models/Story/storylist.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/post.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Social/postshare_page.dart';
import 'package:ARMOYU/Functions/functions_service.dart';
import 'package:ARMOYU/Widgets/Skeletons/cards_skeleton.dart';
import 'package:ARMOYU/Widgets/Skeletons/storycircle_skeleton.dart';
import 'package:ARMOYU/Widgets/storycircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Widgets/Skeletons/posts_skeleton.dart';
import 'package:ARMOYU/Widgets/posts.dart';

class SocialPage extends StatefulWidget {
  final User? currentUser;
  final ScrollController homepageScrollController;

  const SocialPage({
    super.key,
    required this.currentUser,
    required this.homepageScrollController,
  });

  @override
  State<SocialPage> createState() => _SocialPageState();
}

List<Map<String, String>> listTPCard = [];
List<Map<String, String>> listPOPCard = [];

class _SocialPageState extends State<SocialPage>
    with AutomaticKeepAliveClientMixin<SocialPage> {
  @override
  bool get wantKeepAlive => true;

  late final ScrollController _scrollController =
      widget.homepageScrollController;

  // int userID = -1;
  // String userName = 'User Name';
  // String userEmail = 'user@email.com';
  // String useravatar = 'assets/images/armoyu128.png';
  // String userbanner = 'assets/images/test.jpg';

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;

  List<Widget> widgetPosts = [];
  List<StoryList> widgetStoriescard = [];

  Widget? widgetStories;

  @override
  void initState() {
    super.initState();
    // userID = widget.currentUser!.userID!;
    // userName = widget.currentUser!.displayName!;
    // userEmail = widget.currentUser!.userMail!;
    // useravatar = widget.currentUser!.avatar!.mediaURL.minURL;
    // userbanner = widget.currentUser!.banner!.mediaURL.minURL;

    loadSkeletonpost();
    // ScrollController'ı dinle
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });

    loadPosts(postpage);
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  //Hikaye Fonksiyon
  Future<void> fetchstoryWidget(int page) async {
    FunctionsStory f = FunctionsStory();
    Map<String, dynamic> response = await f.stories();
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (page == 1) {
      widgetStoriescard.clear();
    }

    if (response["icerik"].length == 0) {
      widgetStoriescard.add(
        StoryList(
          ownerID: ARMOYU.appUsers[ARMOYU.selectedUser].userID!,
          ownerusername: "Hikayen",
          owneravatar:
              ARMOYU.appUsers[ARMOYU.selectedUser].avatar!.mediaURL.minURL,
          story: null,
          isView: true,
        ),
      );
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Story> widgetStory = [];

      if (i == 0) {
        if (response["icerik"][i]["oyuncu_ID"].toString() !=
            ARMOYU.appUsers[ARMOYU.selectedUser].userID.toString()) {
          widgetStoriescard.add(
            StoryList(
              ownerID: ARMOYU.appUsers[ARMOYU.selectedUser].userID!,
              ownerusername: "Hikayen",
              owneravatar:
                  ARMOYU.appUsers[ARMOYU.selectedUser].avatar!.mediaURL.minURL,
              story: null,
              isView: true,
            ),
          );
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
      widgetStoriescard.add(
        StoryList(
          ownerID: response["icerik"][i]["oyuncu_ID"],
          ownerusername: response["icerik"][i]["oyuncu_kadi"],
          owneravatar: response["icerik"][i]["oyuncu_avatar"],
          story: widgetStory,
          isView: viewstory,
        ),
      );
    }

    if (mounted) {
      setState(() {
        widgetStories = WidgetStorycircle(
          content: widgetStoriescard,
        );
      });
    }
  }

  Future<void> _handleRefresh() async {
    isRefreshing = true;
    await loadPosts(1);
    isRefreshing = false;
  }

  // Yeni veri yükleme işlemi
  Future<void> _loadMoreData() async {
    if (!postpageproccess) {
      setState(() {
        postpageproccess = true;
      });
      await loadPosts(postpage);
    }
  }

  Future<void> loadPostsv2(int page) async {
    FunctionService f = FunctionService();

    Map<String, dynamic> response = await f.getPosts(page);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }

    if (response["icerik"].length == 0) {
      return;
    }
    if (page == 1) {
      widgetPosts.clear();
    }

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
                bigURL: mediaInfo["fotourl"],
                normalURL: mediaInfo["fotoufakurl"],
                minURL: mediaInfo["fotominnakurl"],
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
                    bigURL: firstthreelike["avatar"],
                    normalURL: firstthreelike["avatar"],
                    minURL: firstthreelike["avatar"],
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

      if (mounted) {
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
        setState(() {
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
                  bigURL: response["icerik"][i]["sahipavatarminnak"],
                  normalURL: response["icerik"][i]["sahipavatarminnak"],
                  minURL: response["icerik"][i]["sahipavatarminnak"],
                ),
              ),
            ),
            firstthreecomment: comments,
            firstthreelike: likers,
            location: response["icerik"][i]["paylasimkonum"],
          );
          widgetPosts.add(
            TwitterPostWidget(post: post),
          );

          if (i / 3 == 1) {
            widgetPosts.add(
              ARMOYUWidget(
                      scrollController: ScrollController(),
                      content: listPOPCard,
                      firstFetch: listPOPCard.isEmpty)
                  .widgetPOPlist(),
            );
          }
          if (i / 7 == 1) {
            widgetPosts.add(
              ARMOYUWidget(
                      scrollController: ScrollController(),
                      content: listTPCard,
                      firstFetch: listTPCard.isEmpty)
                  .widgetTPlist(),
            );
          }
        });
      }
    }
    postpage++;
  }

  Future<void> loadSkeletonpost() async {
    widgetStories =
        SkeletonStorycircle(currentUser: widget.currentUser, count: 11);

    widgetPosts.clear();

    widgetPosts.add(const SkeletonSocailPosts());
    widgetPosts.add(const SkeletonSocailPosts());
    widgetPosts.add(const SkeletonSocailPosts());
    widgetPosts.add(const SkeletonCustomCards(
        count: 5, icon: Icon(Icons.view_comfortable_sharp)));
    widgetPosts.add(const SkeletonSocailPosts());
    widgetPosts.add(const SkeletonSocailPosts());
    widgetPosts.add(const SkeletonSocailPosts());
    widgetPosts.add(const SkeletonSocailPosts());
    setstatefunction();
  }

  Future<void> loadPosts(int page) async {
    if (page == 1) {
      postpage = 1;
      fetchstoryWidget(1);
    }
    await loadPostsv2(page);
    setState(() {
      postpageproccess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await _handleRefresh();
            },
          ),
          SliverToBoxAdapter(child: widgetStories),
          const SliverToBoxAdapter(child: SizedBox(height: 1)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return widgetPosts[index];
              },
              childCount: widgetPosts.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Visibility(
              visible: postpageproccess,
              child: Container(
                height: 100,
                color: ARMOYU.appbarColor,
                child: const CupertinoActivityIndicator(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "socailshare${widget.currentUser!.userID}",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PostSharePage(),
            ),
          );
        },
        backgroundColor: ARMOYU.buttonColor,
        child: const Icon(
          Icons.post_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
