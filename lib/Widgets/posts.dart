// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sort_child_properties_last

import 'dart:developer';
import 'dart:ui';

import 'package:ARMOYU/Core/screen.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Functions/posts.dart';
import '../Screens/FullScreenImagePage.dart';
import '../Screens/profile_page.dart';

class TwitterPostWidget extends StatefulWidget {
  final int userID;
  final String profileImageUrl;
  final String username;
  final int postID;

  final String postText;
  final String postDate;
  final List<int> mediaIDs;
  final List<int> mediaownerIDs;
  final List<String> mediaUrls;
  final List<String> mediabetterUrls;
  final String postlikeCount;
  final String postcommentCount;

  final int postMelike;
  final int postMecomment;

  TwitterPostWidget({
    required this.userID,
    required this.profileImageUrl,
    required this.username,
    required this.postID,
    required this.postText,
    required this.postDate,
    required this.mediaIDs,
    required this.mediaownerIDs,
    required this.mediaUrls,
    required this.mediabetterUrls,
    required this.postlikeCount,
    required this.postcommentCount,
    required this.postMelike,
    required this.postMecomment,
  });

  @override
  State<TwitterPostWidget> createState() => _TwitterPostWidgetState();
}

class _TwitterPostWidgetState extends State<TwitterPostWidget> {
  @override
  Widget build(BuildContext context) {
    //Like Buton
    Icon postlikeIcon = Icon(Icons.favorite_outline);
    Color postlikeColor = Colors.grey;
    if (widget.postMelike == 1) {
      postlikeIcon = Icon(Icons.favorite);
      postlikeColor = Colors.red;
    }

    //Comment Buton
    Icon postcommentIcon = Icon(Icons.comment_outlined);
    Color postcommentColor = Colors.grey;
    if (widget.postMecomment == 1) {
      postcommentIcon = Icon(Icons.comment);
      postcommentColor = Colors.blue;
    }

    //Repost Buton
    Icon postrepostIcon = Icon(Icons.cyclone_outlined);
    Color postrepostColor = Colors.grey;
    if (widget.postMecomment == 1) {
      postrepostIcon = Icon(Icons.cyclone);
      postrepostColor = Colors.green;
    }

    return Container(
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade900,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      // Tıklama işlemlerinizi burada gerçekleştirin
                      // Örneğin, bir işlevi çağırabilir veya bir sayfaya yönlendirebilirsiniz.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  userID: widget.userID, appbar: true)));
                    },
                    child: CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(widget.profileImageUrl),
                        radius: 20)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.postDate,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuEntry> Popuppostlist = [];

                        if (widget.userID == User.ID) {
                          Popuppostlist.add(PopupMenuItem(
                            child: Text("Paylaşımı Sil"),
                            value: "delete",
                          ));
                        }

                        Popuppostlist.add(PopupMenuItem(
                          child: Text("Şikayet Et"),
                          value: "report",
                        ));
                        return Popuppostlist;
                      },
                      onSelected: (value) async {
                        if (value == "delete") {
                          FunctionsPosts funct = FunctionsPosts();
                          Map<String, dynamic> response =
                              await funct.remove(widget.postID);
                          if (response["durum"] == 0) {
                            log(response["aciklama"]);
                            return;
                          }
                          log(response["aciklama"]);
                        } else if (value == "report") {
                          // Şikayet etme işlemi burada gerçekleştirin
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child:
                  _buildPostText()), // Tıklanabilir metin için yeni fonksiyon
          SizedBox(height: 5),
          Center(
              child: _buildMediaContent(
                  context)), // Medya içeriği için yeni fonksiyon

          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            child: Row(
              children: [
                Spacer(),
                IconButton(
                  iconSize: 25,
                  icon: postlikeIcon,
                  color: postlikeColor,
                  onPressed: () async {
                    FunctionsPosts funct = FunctionsPosts();
                    await funct.likeordislike(widget.postID);

                    setState(() {
                      postlikeColor =
                          Colors.red; // Yeni rengi ayarlayın (örneğin, kırmızı)
                    });
                  },
                ),
                SizedBox(width: 5),
                Text(
                  widget.postlikeCount,
                  style: TextStyle(color: Colors.grey),
                ),
                Spacer(),
                IconButton(
                  iconSize: 25,
                  icon: postcommentIcon,
                  color: postcommentColor,
                  onPressed: () {},
                ),
                SizedBox(width: 5),
                Text(
                  widget.postcommentCount,
                  style: TextStyle(color: Colors.grey),
                ), // Yorum simgesi
                Spacer(),
                IconButton(
                  iconSize: 25,
                  icon: postrepostIcon,
                  color: postrepostColor,
                  onPressed: () {},
                ), // Retweet simgesi (yeşil renkte)
                Spacer(),
                Icon(Icons.share_outlined,
                    color: Colors.grey), // Paylaşım simgesi
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostText() {
    final words = widget.postText.split(' ');

    final textSpans = words.map((word) {
      if (word.startsWith('#')) {
        return TextSpan(
          text: word + ' ',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // Burada # işaretine tıklandığında yapılacak işlemi ekleyin
              print('Tapped on hashtag: $word');
            },
        );
      }
      return TextSpan(text: word + ' ');
    }).toList();

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    Widget mediaSablon(String mediaUrl,
        {BoxFit? fit = BoxFit.cover,
        double? width = 100,
        double? height = 100}) {
      return CachedNetworkImage(
        imageUrl: mediaUrl,
        fit: fit,
        width: width,
        height: height,
      );
    }

    Widget Mediayerlesim = Row();

    if (widget.mediaUrls.isNotEmpty) {
      List<Row> mediaItems = [];

      List<GestureDetector> mediarow1 = [];
      List<GestureDetector> mediarow2 = [];

      for (int i = 0; i < widget.mediaUrls.length; i++) {
        if (i > 3) {
          continue;
        }
        double mediawidth = Screen.screenWidth;
        double mediaheight = Screen.screenHeight;
        if (widget.mediaUrls.length == 1) {
          mediawidth = mediawidth / 1;
          // mediawidth = mediawidth / 1.09;
          mediaheight = mediaheight / 2;
        } else if (widget.mediaUrls.length == 2) {
          mediawidth = mediawidth / 2;
          // mediawidth = mediawidth / 2.18;
          mediaheight = mediaheight / 4;
        } else if (widget.mediaUrls.length == 3) {
          if (i == 0) {
            mediawidth = mediawidth / 1;
            // mediawidth = mediawidth / 1.09;
            mediaheight = mediaheight / 2.5;
          } else {
            mediawidth = mediawidth / 2;
            // mediawidth = mediawidth / 2.18;
            mediaheight = mediaheight / 4;
          }
        } else if (widget.mediaUrls.length >= 4) {
          mediawidth = mediawidth / 2;
          // mediawidth = mediawidth / 2.19;
          mediaheight = mediaheight / 4;
        }

        GestureDetector aa = GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FullScreenImagePage(
                images: widget.mediabetterUrls,
                imagesID: widget.mediaIDs,
                imagesownerID: widget.mediaownerIDs,
                initialIndex: i,
              ),
            ));
          },
          child: mediaSablon(widget.mediaUrls[i],
              width: mediawidth, height: mediaheight),
        );
        if (widget.mediaUrls.length == 3) {
          if (i == 0) {
            mediarow1.add(aa);
          } else {
            mediarow2.add(aa);
          }
        } else if (widget.mediaUrls.length >= 4) {
          if (i == 0 || i == 1) {
            mediarow1.add(aa);
          } else {
            mediarow2.add(aa);
          }
        } else {
          mediarow1.add(aa);
        }
      }
      mediaItems.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mediarow1,
      ));
      mediaItems.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mediarow2,
      ));
      /////////////////////////////////////////////////

      /////////////////////////////////////////////////
      Mediayerlesim = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mediaItems,
      );
    }
    return Mediayerlesim;
  }
}
