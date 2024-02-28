import 'dart:async';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Story/story.dart';
import 'package:ARMOYU/Screens/Utility/galleryscreen_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ARMOYU/Services/User.dart';

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
                  if (widget.story[0].ownerusername == User.userName) {
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
                    child: widget.story[0].ownerusername == User.userName
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
                widget.story[0].ownerusername == User.userName
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
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 20,
                color: Colors.blue,
              ),
            ]),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(User.avatar),
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
            ),
          ],
        ),
      ),
    );
  }
}
