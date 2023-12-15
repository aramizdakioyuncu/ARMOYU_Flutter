// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, must_be_immutable

import 'dart:io';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ARMOYU/Services/User.dart';

import 'package:flutter/material.dart';

// ...

class StoryScreenPage extends StatelessWidget {
  final List<String> images; // Gezdirilecek fotoğrafların listesi
  final List<int>? imagesID; // Gezdirilecek fotoğrafların ID listesi
  final List<int>? imagesownerID; // Gezdirilecek fotoğrafların ID listesi
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi
  bool? isFile = false; // Yerel mi

  StoryScreenPage({
    required this.images,
    required this.initialIndex,
    this.imagesID,
    this.imagesownerID,
    this.isFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: <Widget>[],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        child: Center(
                          child: Hero(
                            tag: 'imageTag',
                            child: isFile == true
                                ? Image.file(
                                    File(images[index]),
                                    height: ARMOYU.screenHeight / 1,
                                    width: ARMOYU.screenHeight / 1,
                                    fit: BoxFit.contain,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: images[index],
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
                  padding: EdgeInsets.all(5),
                  height: 55,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
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
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: const [
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
    );
  }
}
