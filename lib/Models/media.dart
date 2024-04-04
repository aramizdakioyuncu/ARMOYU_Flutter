import 'dart:developer';
import 'dart:io';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Media {
  int mediaID;
  XFile? mediaXFile;
  int? ownerID;
  String? ownerusername;
  String? owneravatar;
  String? mediaTime;
  String? mediaType;
  MediaURL mediaURL;
  String? mediaDirection;

  Media({
    required this.mediaID,
    this.mediaXFile,
    this.ownerID,
    this.ownerusername,
    this.owneravatar,
    this.mediaTime,
    this.mediaType,
    required this.mediaURL,
    this.mediaDirection,
  });

  static Widget mediaList(List<Media> list, Function setState,
      {bool big = false}) {
    double imgheight = 100;
    double imgwidgth = 100;
    double closeSize = 16;

    if (big) {
      imgheight = 500;
      imgwidgth = ARMOYU.screenWidth - 50;
      closeSize = 30;
    }
    return SizedBox(
      height: imgheight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          if (index + 1 == list.length + 1) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: imgwidgth,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: InkWell(
                    onTap: () async {
                      List<XFile> selectedImages = await AppCore.pickImages();
                      if (selectedImages.isNotEmpty) {
                        for (XFile element in selectedImages) {
                          list.add(
                            Media(
                              mediaXFile: element,
                              mediaID: element.hashCode,
                              mediaURL: MediaURL(
                                bigURL: element.path,
                                normalURL: element.path,
                                minURL: element.path,
                              ),
                            ),
                          );
                          setState();
                        }
                      }
                    },
                    child: const Icon(Icons.add_a_photo_rounded)),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MediaViewer(
                    media: list,
                    initialIndex: index,
                    isFile: true,
                  ),
                ));
              },
              child: Container(
                width: imgwidgth,
                height: imgheight,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    Image.file(
                      File(list[index].mediaURL.bigURL),
                      fit: BoxFit.contain,
                      height: imgheight,
                      width: imgwidgth,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          log("a");
                          list.removeAt(index);
                          setState();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5)),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: closeSize,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MediaURL {
  String bigURL;
  String normalURL;
  String minURL;

  MediaURL({
    required this.bigURL,
    required this.normalURL,
    required this.minURL,
  });
}
