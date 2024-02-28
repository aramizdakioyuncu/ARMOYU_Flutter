// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/story.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:flutter/material.dart';

class StoryPublishPage extends StatefulWidget {
  final String imageURL; // Gezdirilecek fotoğrafların listesi
  final int imageID; // Gezdirilecek fotoğrafların ID listesi

  const StoryPublishPage({
    super.key,
    required this.imageURL,
    required this.imageID,
  });

  @override
  StoryScreenPageWidget createState() => StoryScreenPageWidget();
}

class StoryScreenPageWidget extends State<StoryPublishPage> {
  bool isEveryonepublish = true;

  @override
  void initState() {
    super.initState();
    log(widget.imageURL.toString());
    log(widget.imageID.toString());
  }

  Future<void> publishstory(String storyURL, bool isEveryonepublish) async {
    FunctionsStory f = FunctionsStory();
    Map<String, dynamic> response =
        await f.addstory(storyURL, isEveryonepublish);
    if (response["durum"] == 0) {
      log(response["aciklama"]);
      return;
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close)),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.text_fields_rounded,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.tag_faces_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.music_note_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.workspaces_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz_outlined,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Stack(
                  children: [
                    InteractiveViewer(
                      child: Center(
                        child: Hero(
                          tag: 'imageTag',
                          child: CachedNetworkImage(
                            imageUrl: widget.imageURL,
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
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 20,
                color: Colors.blue,
              ),
            ]),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: isEveryonepublish
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white))
                              : null,
                          onPressed: () {
                            isEveryonepublish = true;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                foregroundImage:
                                    CachedNetworkImageProvider(User.avatar),
                                radius: 16,
                              ),
                              const SizedBox(width: 10),
                              const Text("Herkes"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: !isEveryonepublish
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white))
                              : null,
                          onPressed: () {
                            isEveryonepublish = false;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(124),
                                ),
                                child: const Icon(Icons.stars_rounded,
                                    color: Colors.green),
                              ),
                              const SizedBox(width: 10),
                              const Text("Arkadaşlar"),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              publishstory(widget.imageURL, isEveryonepublish);
                            },
                            icon: const Icon(Icons.send, size: 22)),
                      ],
                    ),
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
