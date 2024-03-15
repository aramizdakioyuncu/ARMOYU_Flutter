import 'dart:async';
import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/story.dart';
import 'package:ARMOYU/Models/Story/story.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Utility/galleryscreen_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryScreenPage extends StatefulWidget {
  final List<Story> story; // Gezdirilecek fotoğrafların listesi

  const StoryScreenPage({
    super.key,
    required this.story,
  });

  @override
  StoryScreenPageWidget createState() => StoryScreenPageWidget();
}

class StoryScreenPageWidget extends State<StoryScreenPage> {
  final PageController _pageController = PageController(initialPage: 0);

  int initialIndex = 0;
  late Timer _timer;
  double _containerWidth = 0;
  bool _isPaused = false;

  bool viewlistProcess = false;
  bool storyviewProcess = false;
  bool firststoryviewProcess = false;
  List<User> viewerlist = [];

  @override
  void initState() {
    super.initState();

    _startTimer();
    _pageController.addListener(() {
      if (_pageController.page == _pageController.page?.roundToDouble()) {
        setState(() {
          _containerWidth = 1;
          _startAnimation();
        });
      }
    });
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

    FunctionsStory funct = FunctionsStory();
    Map<String, dynamic> response = await funct.view(story.storyID);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      storyviewProcess = false;
      firststoryviewProcess = true;
      return;
    }
    firststoryviewProcess = true;

    storyviewProcess = false;
    if (mounted) {
      setState(() {
        story.isView = 1;
      });
    }
  }

  void _startTimer() {
    _containerWidth = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!_isPaused) {
        setState(() {
          _containerWidth += 1;
          if (_containerWidth >= MediaQuery.of(context).size.width) {
            if (widget.story.length <= initialIndex + 1) {
              _timer.cancel();
              Navigator.of(context).pop();
              return;
            }

            setState(() {
              initialIndex = _pageController.page!.toInt() + 1;
              _pageController.animateToPage(
                initialIndex,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeInOut,
              );
            });
            _timer.cancel();
            _startTimer();
          }
        });
      }
    });
  }

  void _startAnimation() {
    setState(() {
      _isPaused = false;
    });
  }

  void _stopAnimation() {
    setState(() {
      _isPaused = true;
    });
  }

  Future<void> fetchstoryViewlist(int storyID) async {
    if (viewlistProcess) {
      return;
    }

    viewlistProcess = true;
    FunctionsStory funct = FunctionsStory();
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
          avatar: element["hgoruntuleyen_avatar"],
        ),
      );
    }

    viewlistProcess = false;
  }

  void viewmystoryviewlist() {
    _stopAnimation();
    fetchstoryViewlist(widget.story[0].storyID);
    showModalBottomSheet(
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
            onRefresh: () async {
              // getcommentsfetch(PostID, list_comments);
            },
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
                                return viewerlist[index].storyViewUserList();
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
                  if (widget.story[0].ownerusername ==
                      ARMOYU.Appuser.userName) {
                    _stopAnimation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GalleryScreen(),
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
                        widget.story[0].owneravatar,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child:
                        widget.story[0].ownerusername == ARMOYU.Appuser.userName
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
                widget.story[0].ownerusername == ARMOYU.Appuser.userName
                    ? "Hikayen"
                    : widget.story[0].ownerusername,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 5),
              Text(
                widget.story[0].time,
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
        body: Column(
          children: [
            SizedBox(
              height: 1,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1), // Animasyon süresi
                  width: _containerWidth,
                  color: Colors.amber,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: widget.story.length,
                itemBuilder: (context, index) {
                  if (widget.story[index].isView == 0) {
                    storyview(widget.story[index]);
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onLongPressEnd: (details) {
                            _startAnimation();
                          },
                          onLongPressStart: (_) {
                            _stopAnimation();
                          },
                          onTap: () {
                            if (widget.story.length - 1 == initialIndex) {
                              return;
                            }
                            setState(() {
                              initialIndex = _pageController.page!.toInt() + 1;
                              _pageController.animateToPage(
                                initialIndex,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          onTapUp: (details) {
                            _startAnimation();
                          },
                          onVerticalDragUpdate: (details) {
                            if (widget.story[index].ownerID !=
                                ARMOYU.Appuser.userID) {
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
                                      imageUrl: widget.story[index].media,
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
                      if (widget.story[index].ownerusername !=
                          ARMOYU.Appuser.userName)
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                  foregroundImage: CachedNetworkImageProvider(
                                      ARMOYU.Appuser.avatar!.mediaURL.minURL),
                                  radius: 20),
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const TextField(
                                      // controller: controller_message,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
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
                                        if (widget.story[index].isLike == 0) {
                                          FunctionsStory funct =
                                              FunctionsStory();
                                          Map<String, dynamic> response =
                                              await funct.like(
                                                  widget.story[index].storyID);
                                          if (response["durum"] == 0) {
                                            log(response["aciklama"]);
                                            return;
                                          }

                                          setState(() {
                                            widget.story[index].isLike = 1;
                                          });
                                        } else {
                                          FunctionsStory funct =
                                              FunctionsStory();
                                          Map<String, dynamic> response =
                                              await funct.likeremove(
                                                  widget.story[index].storyID);
                                          if (response["durum"] == 0) {
                                            log(response["aciklama"]);
                                            return;
                                          }

                                          setState(() {
                                            widget.story[index].isLike = 0;
                                          });
                                        }
                                      },
                                      icon: widget.story[index].isLike == 1
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
        ),
      ),
    );
  }
}
