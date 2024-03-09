import 'dart:developer';
import 'dart:io';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ARMOYU/Services/appuser.dart';

import 'package:flutter/material.dart';

class FullScreenImagePage extends StatefulWidget {
  final List<String> images; // Gezdirilecek fotoğrafların listesi
  final List<int>? imagesID; // Gezdirilecek fotoğrafların ID listesi
  final List<int>? imagesownerID; // Gezdirilecek fotoğrafların ID listesi
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi
  final bool? isFile; // Yerel mi
  const FullScreenImagePage({
    super.key,
    required this.images,
    this.imagesID,
    this.imagesownerID,
    required this.initialIndex,
    this.isFile = false,
  });
  @override
  State<FullScreenImagePage> createState() => _FullScreenImageStatePage();
}

class _FullScreenImageStatePage extends State<FullScreenImagePage> {
  bool isRotationedit = false;
  bool isRotationprocces = false;
  double mediaAngle = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ARMOYU.appbarColor,
        actions: <Widget>[
          Visibility(
            visible: isRotationprocces,
            child: const Column(
              children: [
                CircularProgressIndicator(
                  color: Colors.red,
                ),
              ],
            ),
          ),
          Visibility(
            visible: isRotationedit && !isRotationprocces,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    mediaAngle -= 90;
                  },
                  icon: const Icon(Icons.rotate_left_sharp),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isRotationedit && !isRotationprocces,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    mediaAngle += 90;
                  },
                  icon: const Icon(Icons.rotate_right_sharp),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isRotationedit && !isRotationprocces,
            child: Column(
              children: [
                IconButton(
                  onPressed: () async {
                    if (isRotationprocces) {
                      return;
                    }

                    isRotationprocces = true;

                    FunctionsMedia f = FunctionsMedia();
                    Map<String, dynamic> response = await f.rotation(
                        widget.imagesID![widget.initialIndex], mediaAngle);

                    if (response["durum"] == 0) {
                      log(response["aciklama"]);
                      return;
                    }

                    isRotationprocces = false;
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
          Visibility(
            visible:
                (widget.imagesownerID?[widget.initialIndex] == AppUser.ID) &&
                        !isRotationprocces
                    ? true
                    : false,
            child: IconButton(
              icon: const Icon(Icons.crop_rotate_outlined),
              onPressed: () async {
                setState(() {
                  isRotationedit = !isRotationedit;
                });
              },
            ),
          ),
        ],
      ),
      backgroundColor: ARMOYU.bodyColor,
      body: PageView.builder(
        controller: PageController(initialPage: widget.initialIndex),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              InteractiveViewer(
                child: Center(
                  child: Hero(
                    tag: 'imageTag',
                    child: widget.isFile == true
                        ? Transform.rotate(
                            angle: mediaAngle,
                            child: Image.file(
                              File(widget.images[index]),
                              height: ARMOYU.screenHeight / 1,
                              width: ARMOYU.screenHeight / 1,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Transform.rotate(
                            angle: mediaAngle,
                            child: CachedNetworkImage(
                              imageUrl: widget.images[index],
                              height: ARMOYU.screenHeight / 1,
                              width: ARMOYU.screenHeight / 1,
                              fit: BoxFit.contain,
                            ),
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
          );
        },
      ),
    );
  }
}
