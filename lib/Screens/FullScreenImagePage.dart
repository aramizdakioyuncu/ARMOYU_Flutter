// ignore_for_file: prefer_const_constructors

import 'package:ARMOYU/Core/screen.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// ...

class FullScreenImagePage extends StatelessWidget {
  final List<String> images; // Gezdirilecek fotoğrafların listesi
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi

  FullScreenImagePage({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // Üstte bir AppBar ekleyin
        title: Text('Görsel'),
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
                      child: Image.network(
                        images[index],
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
