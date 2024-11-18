import 'dart:io';
import 'dart:math';
import 'package:ARMOYU/app/data/models/ARMOYU/media.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/API/media_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaViewer extends StatefulWidget {
  final User currentUser;
  final List<Media> media; // Gezdirilecek fotoğrafların ID listesi
  final int initialIndex; // Başlangıçtaki fotoğrafin indexi
  final bool? isFile; // Yerel mi
  final bool? isMemory;
  const MediaViewer({
    super.key,
    required this.media,
    required this.initialIndex,
    this.isFile = false,
    this.isMemory = false,
    required this.currentUser,
  });
  @override
  State<MediaViewer> createState() => _MediaViewerPage();
}

class _MediaViewerPage extends State<MediaViewer> {
  bool isRotationedit = false;
  bool isRotationprocces = false;
  double mediaAngle = 0;
  double rotateangle = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: ARMOYU.appbarColor,
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
                    mediaAngle -= pi / 2;
                    rotateangle -= 90;
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
                    mediaAngle += pi / 2;
                    rotateangle += 90;
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
                    MediaAPI f = MediaAPI(currentUser: widget.currentUser);
                    Map<String, dynamic> response = await f.rotation(
                      mediaID: widget.media[widget.initialIndex].mediaID,
                      rotate: 360 - (rotateangle % 360),
                    );

                    if (response["durum"] == 0) {
                      mediaAngle = 0;
                      isRotationedit = false;
                      isRotationprocces = false;
                      return;
                    }

                    isRotationedit = false;
                    isRotationprocces = false;
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
          Visibility(
            visible: (widget.media[widget.initialIndex].ownerID ==
                        widget.currentUser.userID) &&
                    !isRotationprocces
                ? true
                : false,
            child: IconButton(
              icon: const Icon(Icons.crop_rotate_outlined),
              onPressed: () async {
                setState(() {
                  isRotationedit = !isRotationedit;
                  mediaAngle = 0;
                });
              },
            ),
          ),
        ],
      ),
      body: Transform.rotate(
        angle: mediaAngle,
        child: PhotoViewGallery.builder(
          scrollPhysics: isRotationedit
              ? const NeverScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          pageController: PageController(initialPage: widget.initialIndex),
          itemCount: widget.media.length,
          backgroundDecoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
          ),
          builder: (BuildContext context, int index) {
            ImageProvider imageProvider;

            if (widget.isFile!) {
              imageProvider = FileImage(
                File(
                  widget.media[index].mediaURL.bigURL.value,
                ),
              );
            } else if (widget.isMemory!) {
              imageProvider = MemoryImage(
                widget.media[index].mediaBytes!,
              );
            } else {
              imageProvider = CachedNetworkImageProvider(
                widget.media[index].mediaURL.bigURL.value,
              );
            }

            return PhotoViewGalleryPageOptions(
              imageProvider: imageProvider,
              initialScale: PhotoViewComputedScale.contained * 1,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: widget.media[index].mediaID),
            );
          },
          loadingBuilder: (context, event) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CupertinoActivityIndicator(),
            ),
          ),
          // onPageChanged: onPageChanged,
        ),
      ),
    );
  }
}
