import 'dart:async';
import 'dart:developer';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/story.dart';
import 'package:ARMOYU/Models/Story/story.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Utility/galleryscreen_page.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ARMOYU/Services/appuser.dart';
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
    viewerlist.add(
      User(
        username: "berkay",
        displayname: "berkay",
        avatar:
            "https://cdn1.img.sputniknews.com.tr/img/101440/54/1014405478_401:0:2001:1600_1920x0_80_0_0_6a581dbf63ff5ffc82f519201bee7f55.jpg",
      ),
    );
    // for (var element in response["icerik"]) {
    //   viewerlist.add(
    //     User(
    //       username: element["goruntuleyen_userlogin"],
    //       displayname: element["goruntuleyen_adi"],
    //       avatar: element["goruntuleyen_avatar"],
    //     ),
    //   );
    // }

    viewlistProcess = false;
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
                  if (widget.story[0].ownerusername == AppUser.userName) {
                    _stopAnimation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryScreen(),
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
                    child: widget.story[0].ownerusername == AppUser.userName
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
                widget.story[0].ownerusername == AppUser.userName
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
                controller: _pageController,
                itemCount: widget.story.length,
                itemBuilder: (context, index) {
                  Story storydetail = widget.story[index];

                  return GestureDetector(
                    onLongPressEnd: (details) {
                      _startAnimation();
                    },
                    onTapDown: (_) {
                      _stopAnimation();
                    },
                    onTapUp: (details) {
                      _startAnimation();
                    },
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          child: Center(
                            child: Hero(
                              tag: 'imageTag',
                              child: CachedNetworkImage(
                                imageUrl: storydetail.media,
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
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  color: Colors.blue,
                ),
              ],
            ),
            if (widget.story[0].ownerusername != AppUser.userName)
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(AppUser.avatar),
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.favorite_outline,
                            size: 22,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.send,
                            size: 22,
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
                                        CustomText().Costum1("YORUMLAR"),
                                        const SizedBox(height: 5),
                                        const Divider(),
                                        Expanded(
                                          child: viewerlist.isEmpty
                                              ? const CupertinoActivityIndicator()
                                              : ListView.builder(
                                                  itemCount: 2,
                                                  itemBuilder:
                                                      (context, index) {
                                                    User aa = viewerlist[index];
                                                    return ListTile(
                                                      title:
                                                          Text(aa.displayname),
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
        ),
      ),
    );
  }
}
