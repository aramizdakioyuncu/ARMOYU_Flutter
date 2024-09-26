import 'dart:async';
import 'dart:developer';
import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/story.dart';
import 'package:ARMOYU/app/data/models/Story/story.dart';
import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/Utility/galleryscreen_page.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryScreenPage extends StatefulWidget {
  final User currentUser;
  final int storyIndex; // Gezdirilecek hikaye indexi
  final List<StoryList> storyList; // Gezdirilecek Hikayelerin listesi

  const StoryScreenPage({
    super.key,
    required this.currentUser,
    required this.storyList,
    required this.storyIndex,
  });

  @override
  StoryScreenPageWidget createState() => StoryScreenPageWidget();
}

class StoryScreenPageWidget extends State<StoryScreenPage> {
  late Timer _timer;
  late int storyIndex;
  late PageController _pageControllerStory;
  late PageController _pageController;
  int initialStoryIndex = 0;
  double _containerWidth = 0;
  double _containerWidthValue = 0;
  bool _isPaused = false;

  bool viewlistProcess = false;
  bool storyviewProcess = false;
  bool firststoryviewProcess = false;
  List<User> viewerlist = [];

  @override
  void initState() {
    super.initState();
    storyIndex = widget.storyIndex;
    _pageControllerStory = PageController(initialPage: storyIndex);
    _pageController = PageController(initialPage: initialStoryIndex);

    _startTimer();
    _pageController.addListener(() {
      if (_pageController.page == _pageController.page?.roundToDouble()) {
        _containerWidth = 1;
        _startAnimation();
        setstatefunction();
      }
    });
  }

  setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> storyview(Story story) async {
    if (firststoryviewProcess) {
      return;
    }
    if (storyviewProcess) {
      return;
    }

    storyviewProcess = true;

    FunctionsStory funct = FunctionsStory(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.view(story.storyID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      storyviewProcess = false;
      firststoryviewProcess = true;
      return;
    }
    firststoryviewProcess = true;

    storyviewProcess = false;
    story.isView = 1;
    setstatefunction();
  }

  void onTapeventStory() {
    if (initialStoryIndex + 1 < widget.storyList[storyIndex].story!.length) {
      log("Story içi değişiklik");
      initialStoryIndex++;
      _pageController.jumpToPage(initialStoryIndex);
      _timer.cancel();
      _startTimer();
      return;
    }

    if (initialStoryIndex + 1 == widget.storyList[storyIndex].story!.length &&
        storyIndex + 1 < widget.storyList.length) {
      log("Storyler arası Değişiklik");

      storyIndex++;
      initialStoryIndex = 0;
      _pageControllerStory.jumpToPage(storyIndex);

      _timer.cancel();
      _startTimer();
      return;
    }

    if (widget.storyList[storyIndex].story!.length == initialStoryIndex + 1 &&
        widget.storyList.length == storyIndex + 1) {
      log("Story Çıkış");

      _timer.cancel();

      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    setstatefunction();
  }

  void _startTimer() {
    _containerWidth = 0;
    _containerWidthValue = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!_isPaused) {
        _containerWidth += 1;
        _containerWidthValue =
            _containerWidth / MediaQuery.of(context).size.width;
        if (_containerWidth >= MediaQuery.of(context).size.width) {
          onTapeventStory();
        }
      }
    });
  }

  void _startAnimation() {
    _isPaused = false;
    setstatefunction();
  }

  void _stopAnimation() {
    _isPaused = true;
    setstatefunction();
  }

  Future<void> fetchstoryViewlist(int storyID) async {
    if (viewlistProcess) {
      return;
    }

    viewlistProcess = true;
    FunctionsStory funct = FunctionsStory(currentUser: widget.currentUser);
    Map<String, dynamic> response = await funct.fetchviewlist(storyID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      viewlistProcess = false;
      return;
    }

    viewerlist.clear();

    for (var element in response["icerik"]) {
      viewerlist.add(
        User(
          userName: element["hgoruntuleyen_kullaniciad"],
          displayName: element["hgoruntuleyen_adsoyad"],
          status: element["hgoruntuleyen_begenme"] == 1 ? true : false,
          avatar: Media(
            mediaID: 0,
            mediaURL: MediaURL(
              bigURL: element["hgoruntuleyen_avatar"],
              normalURL: element["hgoruntuleyen_avatar"],
              minURL: element["hgoruntuleyen_avatar"],
            ),
          ),
        ),
      );
    }

    viewlistProcess = false;
  }

  Future<void> viewmystoryviewlist() async {
    _stopAnimation();
    fetchstoryViewlist(
        widget.storyList[storyIndex].story![initialStoryIndex].storyID);
    final result = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      backgroundColor: ARMOYU.bodyColor,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RefreshIndicator(
            onRefresh: () async {},
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomText.costum1("Görüntüleyenler"),
                    const SizedBox(height: 5),
                    const Divider(),
                    Expanded(
                      child: viewerlist.isEmpty
                          ? const CupertinoActivityIndicator()
                          : ListView.builder(
                              itemCount: viewerlist.length,
                              itemBuilder: (context, index) {
                                return viewerlist[index].storyViewUserList(
                                  isLiked: viewerlist[index].status!,
                                );
                              },
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

    if (result != null) {
      _startAnimation();
    } else {
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  if (widget.storyList[storyIndex].story![initialStoryIndex]
                          .ownerusername ==
                      widget.currentUser.userName) {
                    _stopAnimation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GalleryScreen(currentUser: widget.currentUser),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      image: CachedNetworkImageProvider(
                        widget.storyList[storyIndex].story![initialStoryIndex]
                            .owneravatar,
                        errorListener: (p0) =>
                            const CupertinoActivityIndicator(),
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: widget.storyList[storyIndex]
                                .story![initialStoryIndex].ownerusername ==
                            widget.currentUser.userName
                        ? Container(
                            height: 12,
                            width: 12,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(100, 100),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 10,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                widget.storyList[storyIndex].story![initialStoryIndex]
                            .ownerusername ==
                        widget.currentUser.userName
                    ? "Hikayen"
                    : widget.storyList[storyIndex].owner.userName!,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 5),
              Text(
                widget.storyList[storyIndex].story![initialStoryIndex].time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                // Navigator.of(context).pop();
              },
              icon: const Icon(Icons.more_horiz_outlined),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.storyList.length,
          controller: _pageControllerStory,
          onPageChanged: (value) {
            storyIndex = value;
            _containerWidth = 0;
            _containerWidthValue = 0;
          },
          itemBuilder: (context, indexstoryList) {
            return Column(
              children: [
                SizedBox(
                  height: 5,
                  width: ARMOYU.screenWidth,
                  child: Row(
                    children: List.generate(
                      widget.storyList[indexstoryList].story!.length,
                      (index) {
                        if (index < initialStoryIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SizedBox(
                              width: (ARMOYU.screenWidth -
                                      2 *
                                          widget.storyList[indexstoryList]
                                              .story!.length) /
                                  widget
                                      .storyList[indexstoryList].story!.length,
                              child: LinearProgressIndicator(
                                value: 1,
                                backgroundColor: Colors.grey,
                                color: Colors.white,
                                minHeight: 2,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }
                        if (index == initialStoryIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SizedBox(
                              width: (ARMOYU.screenWidth -
                                      2 *
                                          widget.storyList[indexstoryList]
                                              .story!.length) /
                                  widget
                                      .storyList[indexstoryList].story!.length,
                              child: LinearProgressIndicator(
                                value: _containerWidthValue,
                                backgroundColor: Colors.grey,
                                color: Colors.white,
                                minHeight: 2,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SizedBox(
                            width: (ARMOYU.screenWidth -
                                    2 *
                                        widget.storyList[indexstoryList].story!
                                            .length) /
                                widget.storyList[indexstoryList].story!.length,
                            child: LinearProgressIndicator(
                              value: 0,
                              backgroundColor: Colors.grey,
                              color: Colors.white,
                              minHeight: 2,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: widget.storyList[indexstoryList].story!.length,
                    itemBuilder: (context, index) {
                      if (widget
                              .storyList[indexstoryList].story![index].isView ==
                          0) {
                        storyview(
                            widget.storyList[indexstoryList].story![index]);
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onLongPressEnd: (details) {
                                _startAnimation();
                              },
                              onLongPressStart: (_) {
                                _stopAnimation();
                              },
                              onPanUpdate: (details) {
                                log(details.globalPosition.toString());
                              },

                              onTap: () {
                                onTapeventStory();
                                setstatefunction();
                              },
                              // onTapUp: (details) {
                              //   _startAnimation();
                              // },
                              onVerticalDragUpdate: (details) {
                                if (widget.storyList[indexstoryList]
                                        .story![index].ownerID !=
                                    widget.currentUser.userID) {
                                  return;
                                }
                                if (details.delta.dy > 0) {
                                  //Aşağı kaydırma
                                } else {
                                  //Yukarı kaydırma
                                  viewmystoryviewlist();
                                }
                              },
                              child: Stack(
                                children: [
                                  InteractiveViewer(
                                    scaleEnabled: false,
                                    child: Center(
                                      child: Hero(
                                        tag: 'imageTag',
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                              .storyList[indexstoryList]
                                              .story![index]
                                              .media,
                                          height: ARMOYU.screenHeight / 1,
                                          width: ARMOYU.screenHeight / 1,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onDoubleTap: () {
                                          // Çift tıklayınca yakınlaştırmayı sıfırla
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (widget.storyList[indexstoryList].story![index]
                                  .ownerusername !=
                              widget.currentUser.userName)
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    foregroundImage: CachedNetworkImageProvider(
                                      widget
                                          .currentUser.avatar!.mediaURL.minURL,
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
                                          color: Colors.grey.shade800,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: const TextField(
                                          // controller: controller_message,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                          decoration: InputDecoration(
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
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                          onPressed: () async {
                                            if (widget.storyList[indexstoryList]
                                                    .story![index].isLike ==
                                                0) {
                                              FunctionsStory funct =
                                                  FunctionsStory(
                                                      currentUser:
                                                          widget.currentUser);
                                              Map<String, dynamic> response =
                                                  await funct.like(widget
                                                      .storyList[indexstoryList]
                                                      .story![index]
                                                      .storyID);
                                              if (response["durum"] == 0) {
                                                log(response["aciklama"]);
                                                return;
                                              }

                                              widget.storyList[indexstoryList]
                                                  .story![index].isLike = 1;

                                              setstatefunction();
                                            } else {
                                              FunctionsStory funct =
                                                  FunctionsStory(
                                                      currentUser:
                                                          widget.currentUser);
                                              Map<String, dynamic> response =
                                                  await funct.likeremove(widget
                                                      .storyList[indexstoryList]
                                                      .story![index]
                                                      .storyID);
                                              if (response["durum"] == 0) {
                                                log(response["aciklama"]);
                                                return;
                                              }

                                              setState(() {
                                                widget.storyList[indexstoryList]
                                                    .story![index].isLike = 0;
                                              });
                                            }
                                          },
                                          icon: widget.storyList[indexstoryList]
                                                      .story![index].isLike ==
                                                  1
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  color: Colors.grey,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      viewmystoryviewlist();
                                    },
                                    child: const Column(
                                      children: [
                                        Icon(
                                          Icons.more_horiz_rounded,
                                        ),
                                        Text(
                                          "Daha fazla",
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
