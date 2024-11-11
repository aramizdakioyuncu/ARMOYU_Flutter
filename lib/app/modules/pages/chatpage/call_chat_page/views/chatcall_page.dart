// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatCallPage extends StatefulWidget {
  final User user;

  const ChatCallPage({
    super.key,
    required this.user,
  });

  @override
  State<ChatCallPage> createState() => _ChaCallPageState();
}

bool chatsearchprocess = false;
Color iconsColor = Colors.white;
Color iconsbgColor = Colors.grey.shade700;
TextEditingController callingtext = TextEditingController();

class _ChaCallPageState extends State<ChatCallPage>
    with AutomaticKeepAliveClientMixin<ChatCallPage> {
  final Stopwatch _stopwatch = Stopwatch();
  final player = AudioPlayer();
  final player2 = AudioPlayer();
//Mic
  // Stream<Uint8List>? stream;
  Stream<List<int>>? stream;
  // late StreamSubscription listener;
//Mic

  bool micMute = false;
  IconData micIcon = Icons.mic;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    callingtext.text = "${CommonKeys.calling.tr}...";
    _stopwatch.start();
    microphoneStart();
  }

  void setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    // listener.cancel();
  }

  Future<void> microphoneStart() async {
    if (await Permission.microphone.request().isGranted) {}
  }

  String formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate() % 60;
    int minutes = (milliseconds / 60000).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return true; // true döndürmek, normal geri tuşu işlevini sürdürür.
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.75),
                    BlendMode.darken,
                  ),
                  image: CachedNetworkImageProvider(
                    widget.user.avatar!.mediaURL.normalURL.value,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 150),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.user.avatar!.mediaURL.minURL.value,
                    width: 150, // Set the desired width
                    height: 150, // Set the desired height
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          widget.user.displayName!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(callingtext.text),
                        const SizedBox(height: 5),
                        Text(formatTime(_stopwatch.elapsedMilliseconds)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                SizedBox(
                  height: 220,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 65.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: iconsbgColor),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  await player.setUrl(
                                      'https://www.sanalsantral.com.tr/tema/default/music/karsilama.mp3');
                                  await player.play();
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              icon: Icon(
                                Icons.surround_sound_outlined,
                                color: iconsColor,
                              ),
                            ),
                          ),
                          Container(
                            width: 65.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: iconsbgColor),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  await player.setUrl(
                                      'https://aramizdakioyuncu.com/galeri/muzikler/11324orijinal1689174596.m4a');
                                  await player.play();
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              icon: const Icon(Icons.video_call),
                              color: iconsColor,
                            ),
                          ),
                          Container(
                            width: 65.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: micIcon != Icons.mic
                                  ? Colors.red
                                  : iconsbgColor,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                if (micMute) {
                                  micMute = false;
                                  micIcon = Icons.mic;
                                } else {
                                  micMute = true;
                                  micIcon = Icons.mic_off;
                                }
                                setstatefunction();

                                try {
                                  await player.setUrl(
                                      'https://aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3');
                                  await player.play();
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              icon: Icon(micIcon),
                              color: iconsColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 65.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: iconsbgColor),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  await player.setUrl(
                                      'https://aramizdakioyuncu.com/muzikler/kalbenhaydisoyle.mp3');
                                  await player.play();
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              icon: const Icon(Icons.numbers_rounded),
                              color: iconsColor,
                            ),
                          ),
                          Container(
                            width: 65.0,
                            height: 65.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  await player.setAsset(
                                      "assets/sounds/calling_end.mp3");
                                  player.play();

                                  // if (mounted) {
                                  //   Navigator.pop(context);
                                  // }
                                  Get.back();
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              icon: const Icon(Icons.call_end),
                              color: iconsColor,
                            ),
                          ),
                          Container(
                            width: 65.0,
                            height: 65.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: iconsbgColor),
                            child: IconButton(
                              onPressed: () async {
                                try {
                                  await player.setUrl(
                                      'https://cdn.muzikmp3indir.club/mp3_files/62ce297a2bc37fe29e72cd5e9bc0161f.mp3');
                                  await player.play();
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              icon: const Icon(Icons.person_add),
                              color: iconsColor,
                            ),
                          ),
                        ],
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
