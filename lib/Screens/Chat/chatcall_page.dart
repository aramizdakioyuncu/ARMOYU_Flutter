// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatCallPage extends StatefulWidget {
  final int userID;
  final String useravatar;
  final String userdisplayname;

  const ChatCallPage({
    super.key,
    required this.userID,
    required this.useravatar,
    required this.userdisplayname,
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
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    callingtext.text = "Aranıyor...";
    _stopwatch.start();
    microphoneStart();
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
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, size: 10),
              SizedBox(width: 5),
              Text(
                "Uçtan uca şifrelenmiş ses",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp),
            onPressed: () async {
              try {
                await player.setUrl(
                    'https://cdn.pixabay.com/audio/2022/09/21/audio_51f53043d7.mp3');
                await player.play();
                if (mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                log(e.toString());
              }
            },
          ),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 50),
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.useravatar,
                width: 100, // Set the desired width
                height: 100, // Set the desired height
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
                      widget.userdisplayname,
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
                            shape: BoxShape.circle, color: iconsbgColor),
                        child: IconButton(
                          onPressed: () async {
                            try {
                              await player.setUrl(
                                  'https://aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3');
                              await player.play();
                            } catch (e) {
                              log(e.toString());
                            }
                          },
                          icon: const Icon(Icons.mic_off),
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
                            shape: BoxShape.circle, color: Colors.red),
                        child: IconButton(
                          onPressed: () async {
                            try {
                              await player.setUrl(
                                  'https://cdn.pixabay.com/audio/2022/09/21/audio_51f53043d7.mp3');
                              await player.play();

                              if (mounted) {
                                Navigator.pop(context);
                              }
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
      ),
    );
  }
}
