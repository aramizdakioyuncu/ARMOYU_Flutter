import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/posts.dart';
import 'package:ARMOYU/Functions/API_Functions/story.dart';
import 'package:ARMOYU/Models/Social/comment.dart';
import 'package:ARMOYU/Models/Social/like.dart';
import 'package:ARMOYU/Models/Story/story.dart';
import 'package:ARMOYU/Models/Story/storylist.dart';
import 'package:ARMOYU/Models/media.dart';
import 'package:ARMOYU/Models/post.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Social/postshare_page.dart';
import 'package:ARMOYU/Widgets/Skeletons/cards_skeleton.dart';
import 'package:ARMOYU/Widgets/Skeletons/storycircle_skeleton.dart';
import 'package:ARMOYU/Widgets/storycircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ARMOYU/Widgets/Skeletons/posts_skeleton.dart';
import 'package:ARMOYU/Widgets/posts.dart';

class SocialPage extends StatefulWidget {
  final User currentUser;
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

  bool _fetchPostStatus = false;
  int postpage = 1;

  bool _fetchStoryStatus = false;
  int storypage = 1;

  List<Widget> widgetPosts = [];

  Widget? widgetStories;

  @override
  void initState() {
    super.initState();

    loadPosts(fetchRestart: true);
    loadStories(fetchRestart: true);

    // ScrollController'ı dinle
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.5) {
        // Sayfa sonuna geldiğinde yapılacak işlemi burada gerçekleştirin
        _loadMoreData();
      }
    });
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  //Sayfa Yenilenme işlemi
  Future<void> _handleRefresh() async {
    loadStories(fetchRestart: true);
    await loadPosts(fetchRestart: true);
  }

  // Yeni veri yükleme işlemi
  Future<void> _loadMoreData() async {
    await loadPosts();
  }

  //Hikaye Fonksiyon
  Future<void> fetchstoryWidget({bool fetchRestart = false}) async {
    if (_fetchStoryStatus) {
      return;
    }

    if (fetchRestart) {
      if (widget.currentUser.widgetPosts != null) {
        widgetstoryUpdate();
      } else {
        loadSkeletonpost(story: true);
      }
    }

    _fetchStoryStatus = true;
    setstatefunction();

    FunctionsStory f = FunctionsStory(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.stories(storypage);
    if (response["durum"] == 0) {
      log(response["aciklama"]);

      _fetchStoryStatus = false;
      setstatefunction();
      return;
    }

    if (storypage == 1) {
      widget.currentUser.widgetStoriescard = [];
      if (response["icerik"].length == 0) {
        widget.currentUser.widgetStoriescard!.add(
          StoryList(
            owner: User(
              userID: widget.currentUser.userID,
              userName: "Hikayen",
              avatar: widget.currentUser.avatar,
            ),
            story: null,
            isView: true,
          ),
        );
      }
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Story> widgetStory = [];

      if (storypage == 1) {
        if (i == 0) {
          if (response["icerik"][i]["oyuncu_ID"].toString() !=
              widget.currentUser.userID.toString()) {
            widget.currentUser.widgetStoriescard!.add(
              StoryList(
                owner: User(
                  userID: widget.currentUser.userID,
                  userName: "Hikayen",
                  avatar: widget.currentUser.avatar,
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

      widget.currentUser.widgetStoriescard!.add(
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

    _fetchStoryStatus = false;
    setstatefunction();
  }

  Future<void> fetchPosts({bool fetchRestart = false}) async {
    if (_fetchPostStatus) {
      return;
    }
    if (fetchRestart) {
      postpage = 1;

      if (widget.currentUser.widgetPosts != null) {
        widgetpostUpdate(widget.currentUser.widgetPosts!);
      } else {
        loadSkeletonpost(posts: true);
      }

      setstatefunction();
    }

    _fetchPostStatus = true;
    setstatefunction();

    FunctionsPosts f = FunctionsPosts(currentUser: widget.currentUser);
    Map<String, dynamic> response = await f.getPosts(postpage);
    if (response["durum"] == 0) {
      log(response["aciklama"]);

      _fetchPostStatus = false;
      setstatefunction();
      return;
    }

    if (postpage == 1) {
      widgetPosts = [];
      widget.currentUser.widgetPosts = [];
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

      cachedPostlist.add(post);
      widget.currentUser.widgetPosts!.add(post);
    }
    widgetpostUpdate(cachedPostlist);

    _fetchPostStatus = false;
    postpage++;

    setstatefunction();
  }

  void widgetstoryUpdate() {
    if (widget.currentUser.widgetStoriescard == null) {
      return;
    }
    widgetStories = WidgetStorycircle(
      currentUser: widget.currentUser,
      content: widget.currentUser.widgetStoriescard!,
    );
  }

  void widgetpostUpdate(List<Post> list) {
    int counter = 0;
    for (Post postsInfo in list) {
      counter++;

      //Postu ekle
      widgetPosts.add(
        TwitterPostWidget(
          currentUser: widget.currentUser,
          post: postsInfo,
        ),
      );

      //Popülerlik Kartını ekle
      if (counter / 3 == 1 || counter / 12 == 1) {
        widgetPosts.add(
          ARMOYUWidget(
            currentUser: widget.currentUser,
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
            currentUser: widget.currentUser,
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
      widgetStories =
          SkeletonStorycircle(currentUser: widget.currentUser, count: 11);
    }

    if (posts) {
      widget.currentUser.widgetPosts = [];
      widgetPosts = [];

      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonCustomCards(
          count: 5, icon: Icon(Icons.view_comfortable_sharp)));
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
    }

    setstatefunction();
  }

  Future<void> loadStories({bool fetchRestart = false}) async {
    if (fetchRestart) {
      storypage = 1;
    }
    await fetchstoryWidget(fetchRestart: fetchRestart);
    setstatefunction();
  }

  Future<void> loadPosts({bool fetchRestart = false}) async {
    if (fetchRestart) {
      postpage = 1;
    }

    await fetchPosts(fetchRestart: fetchRestart);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.backgroundcolor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
              visible: _fetchPostStatus,
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
        heroTag: "socailshare${widget.currentUser.userID}",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostSharePage(
                currentUser: widget.currentUser,
              ),
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
