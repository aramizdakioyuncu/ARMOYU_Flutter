import 'dart:developer';
import 'dart:io';
import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Core/appcore.dart';
import 'package:ARMOYU/Core/widgets.dart';
import 'package:ARMOYU/Functions/API_Functions/media.dart';
import 'package:ARMOYU/Screens/Story/storypublish_page.dart';
import 'package:ARMOYU/Screens/Utility/newphotoviewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
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

  Widget mediaGallery({
    required context,
    required index,
    required List<Media> medialist,
    bool storyShare = false,
    required Function setstatefunction,
  }) {
    return GestureDetector(
      onTap: () {
        if (storyShare) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoryPublishPage(
                imageID: 1,
                imageURL: medialist[index].mediaURL.bigURL,
              ),
            ),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaViewer(
              media: medialist,
              initialIndex: index,
            ),
          ),
        );
      },
      onLongPress: () {
        if (ownerID != ARMOYU.appUsers[ARMOYU.selectedUser].userID) {
          return;
        }
        showModalBottomSheet<void>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            context: context,
            builder: (BuildContext context) {
              return SafeArea(
                child: Wrap(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            width: ARMOYU.screenWidth / 4,
                            height: 5,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            medialist.removeAt(index);
                            setstatefunction();
                            FunctionsMedia funct = FunctionsMedia();
                            Map<String, dynamic> response =
                                await funct.delete(mediaID);

                            if (response["durum"] == 0) {
                              log(response["aciklama"].toString());
                              ARMOYUWidget.toastNotification(
                                  response["aciklama"].toString());
                              return;
                            }
                          },
                          child: const ListTile(
                            leading: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            title: Text(
                              "Medyayı Sil",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              );
            });
      },
      child: CachedNetworkImage(
        imageUrl: mediaURL.minURL,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CupertinoActivityIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  static Widget mediaList(List<Media> list, Function setState,
      {bool big = false}) {
    double imgheight = 100;
    double imgwidgth = 100;
    double closeSize = 16;

    if (big) {
      imgheight = ARMOYU.screenHeight * 0.6;
      imgwidgth = ARMOYU.screenWidth - 25;
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MediaViewer(
                      media: list,
                      initialIndex: index,
                      isFile: true,
                    ),
                  ),
                );
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
