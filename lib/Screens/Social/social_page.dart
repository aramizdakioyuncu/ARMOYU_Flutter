import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/story.dart';
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
import 'package:flutter/material.dart';
import 'package:ARMOYU/Widgets/Skeletons/posts_skeleton.dart';
import 'package:ARMOYU/Widgets/posts.dart';

class SocialPage extends StatefulWidget {
  final ScrollController homepageScrollController;

  const SocialPage({super.key, required this.homepageScrollController});

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

  int userID = -1;
  String userName = 'User Name';
  String userEmail = 'user@email.com';
  String useravatar = 'assets/images/armoyu128.png';
  String userbanner = 'assets/images/test.jpg';

  int postpage = 1;
  bool postpageproccess = false;
  bool isRefreshing = false;

  List<Widget> widgetPosts = [];

  List<StoryList> widgetStoriescard = [];

  Widget? widgetStories;

  @override
  void initState() {
    super.initState();
    userID = ARMOYU.Appuser.userID!;
    userName = ARMOYU.Appuser.displayName!;
    userEmail = ARMOYU.Appuser.userMail!;
    useravatar = ARMOYU.Appuser.avatar!.mediaURL.minURL;
    userbanner = ARMOYU.Appuser.banner!.mediaURL.minURL;

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
          ownerID: ARMOYU.Appuser.userID!,
          ownerusername: "Hikayen",
          owneravatar: ARMOYU.Appuser.avatar!.mediaURL.minURL,
          story: null,
          isView: true,
        ),
      );
    }

    for (int i = 0; i < response["icerik"].length; i++) {
      List<Story> widgetStory = [];

      if (i == 0) {
        if (response["icerik"][i]["oyuncu_ID"].toString() !=
            ARMOYU.Appuser.userID.toString()) {
          widgetStoriescard.add(
            StoryList(
              ownerID: ARMOYU.Appuser.userID!,
              ownerusername: "Hikayen",
              owneravatar: ARMOYU.Appuser.avatar!.mediaURL.minURL,
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
    loadPosts(1);
    isRefreshing = false;
  }

  // Yeni veri yükleme işlemi
  Future<void> _loadMoreData() async {
    if (!postpageproccess) {
      postpage++;
      postpageproccess = true;
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

    int dynamicItemCount = response["icerik"].length;
    for (int i = 0; i < dynamicItemCount; i++) {
      List<Media> media = [];

      if (response["icerik"][i]["paylasimfoto"].length != 0) {
        int mediaItemCount = response["icerik"][i]["paylasimfoto"].length;

        for (int j = 0; j < mediaItemCount; j++) {
          media.add(
            Media(
              mediaID: response["icerik"][i]["paylasimfoto"][j]["fotoID"],
              ownerID: response["icerik"][i]["sahipID"],
              mediaType: response["icerik"][i]["paylasimfoto"][j]
                  ["paylasimkategori"],
              mediaDirection: response["icerik"][i]["paylasimfoto"][j]
                  ["medyayonu"],
              mediaURL: MediaURL(
                  bigURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotoufakurl"],
                  normalURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotominnakurl"],
                  minURL: response["icerik"][i]["paylasimfoto"][j]
                      ["fotominnakurl"]),
            ),
          );
        }
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
                mediaURL: MediaURL(
                  bigURL: response["icerik"][i]["sahipavatarminnak"],
                  normalURL: response["icerik"][i]["sahipavatarminnak"],
                  minURL: response["icerik"][i]["sahipavatarminnak"],
                ),
              ),
            ),
          );
          widgetPosts.add(
            TwitterPostWidget(
              post: post,
            ),
          );

          if (i / 3 == 1) {
            widgetPosts.add(ARMOYUWidget(
                    scrollController: ScrollController(),
                    content: listPOPCard,
                    firstFetch: listPOPCard.isEmpty)
                .widgetPOPlist());
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
  }

  Future<void> loadSkeletonpost() async {
    setState(() {
      widgetStories = const SkeletonStorycircle(count: 11);
      widgetPosts.clear();

      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts
          .add(const SkeletonCustomCards(count: 5, icon: Icon(Icons.abc)));
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
      widgetPosts.add(const SkeletonSocailPosts());
    });
  }

  Future<void> loadPosts(int page) async {
    if (page == 1) {
      postpage = 1;
      fetchstoryWidget(1);
    }
    await loadPostsv2(page);

    postpageproccess = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: ARMOYU.bodyColor,
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: _handleRefresh,
        child: ListView(
          controller: _scrollController,
          children: [
            SizedBox(child: widgetStories),
            const SizedBox(
              height: 1,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widgetPosts.length,
              itemBuilder: (context, index) {
                return widgetPosts[index];
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PostSharePage(
              appbar: true,
            ),
          ));
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
