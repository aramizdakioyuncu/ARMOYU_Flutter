// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_element, library_private_types_in_public_api, unnecessary_overrides, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, must_call_super, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatCallPage extends StatefulWidget {
  final int userID;
  final String useravatar;
  final String userdisplayname;

  ChatCallPage(
      {required this.userID,
      required this.useravatar,
      required this.userdisplayname});

  @override
  _ChaCallPageState createState() => _ChaCallPageState();
}

final ScrollController _scrollController = ScrollController();

bool chatsearchprocess = false;
Color iconsColor = Colors.white;
Color iconsbgColor = Colors.grey.shade700;
TextEditingController callingtext = TextEditingController();

class _ChaCallPageState extends State<ChatCallPage>
    with AutomaticKeepAliveClientMixin<ChatCallPage> {
  final Stopwatch _stopwatch = Stopwatch();
  final player = AudioPlayer();

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    callingtext.text = "Aranıyor...";
    _stopwatch.start();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {});
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
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında burada özel bir kontrol yapabilirsiniz.
        // Eğer false dönerseniz, geri tuşu işlevsiz olur.
        print("Geri gidemezsin");
        return true; // true döndürmek, normal geri tuşu işlevini sürdürür.
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Row(
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
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () async {
              try {
                await player.setSourceUrl(
                    'https://cdn.pixabay.com/audio/2022/09/21/audio_51f53043d7.mp3');

                await player.resume();

                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
          ),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              SizedBox(height: 50),
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
                      SizedBox(height: 20),
                      Text(
                        widget.userdisplayname,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(callingtext.text),
                      SizedBox(height: 5),
                      Text(formatTime(_stopwatch.elapsedMilliseconds)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100),
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
                                await player.setSourceUrl(
                                    'https://www.sanalsantral.com.tr/tema/default/music/karsilama.mp3');
                                await player.resume();
                              } catch (e) {
                                print(e);
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
                                await player.setSourceUrl(
                                    'https://aramizdakioyuncu.com/galeri/muzikler/11324orijinal1689174596.m4a');
                                await player.resume();
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(Icons.video_call),
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
                                await player.setSourceUrl(
                                    'https://aramizdakioyuncu.com/muzikler/tantasci-yalan.mp3');
                                await player.resume();
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(Icons.mic_off),
                            color: iconsColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                                await player.setSourceUrl(
                                    'https://aramizdakioyuncu.com/muzikler/kalbenhaydisoyle.mp3');
                                await player.resume();
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(Icons.numbers_rounded),
                            color: iconsColor,
                          ),
                        ),
                        Container(
                          width: 65.0,
                          height: 65.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: IconButton(
                            onPressed: () async {
                              try {
                                await player.setSourceUrl(
                                    'https://cdn.pixabay.com/audio/2022/09/21/audio_51f53043d7.mp3');

                                await player.resume();

                                Navigator.pop(context);
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(Icons.call_end),
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
                                await player.setSourceUrl(
                                    'https://cdn.muzikmp3indir.club/mp3_files/62ce297a2bc37fe29e72cd5e9bc0161f.mp3');
                                await player.resume();
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(Icons.person_add),
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
      ),
    );
  }
}
