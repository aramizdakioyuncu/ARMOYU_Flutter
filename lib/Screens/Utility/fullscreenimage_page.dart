// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ARMOYU/Services/User.dart';

import 'package:flutter/material.dart';

// ...

class FullScreenImagePage extends StatelessWidget {
  final List<String> images; // Gezdirilecek fotoğrafların listesi
  final List<int>? imagesID; // Gezdirilecek fotoğrafların ID listesi
  final List<int>? imagesownerID; // Gezdirilecek fotoğrafların ID listesi
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi
  bool? isFile = false; // Yerel mi

  FullScreenImagePage({
    super.key,
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
        actions: <Widget>[
          Visibility(
            visible: imagesownerID?[initialIndex] == User.ID ? true : false,
            child: IconButton(
              icon: const Icon(Icons.crop_rotate_outlined),
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
    );
  }
}
