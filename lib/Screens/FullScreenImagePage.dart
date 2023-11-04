// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'package:ARMOYU/Core/screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Services/User.dart';

// ...

class FullScreenImagePage extends StatelessWidget {
  final List<String> images; // Gezdirilecek fotoğrafların listesi
  final List<int>? imagesID; // Gezdirilecek fotoğrafların ID listesi
  final List<int>? imagesownerID; // Gezdirilecek fotoğrafların ID listesi
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi

  FullScreenImagePage({
    required this.images,
    required this.initialIndex,
    this.imagesID,
    this.imagesownerID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          Visibility(
            visible: imagesownerID?[initialIndex] == User.ID ? true : false,
            child: IconButton(
              icon: Icon(Icons.crop_rotate_outlined),
              onPressed: () {},
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.of(context).pop();
            },
            child: Stack(
              children: [
                InteractiveViewer(
                  child: Center(
                    child: Hero(
                      tag: 'imageTag',
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        height: Screen.screenHeight / 1,
                        width: Screen.screenHeight / 1,
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
    );
  }
}
