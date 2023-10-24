// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:ui';

import 'package:ARMOYU/Core/screen.dart';
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
  final List<String> mediaUrls;
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
    required this.mediaUrls,
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    // Tıklama işlemlerinizi burada gerçekleştirin
                    // Örneğin, bir işlevi çağırabilir veya bir sayfaya yönlendirebilirsiniz.
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  userID: widget.userID,
                                )));
                  },
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.profileImageUrl),
                      radius: 30)),
              SizedBox(width: 16),
              Column(
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
            ],
          ),
          SizedBox(height: 16),
          _buildPostText(), // Tıklanabilir metin için yeni fonksiyon
          SizedBox(height: 16),
          Center(
              child: _buildMediaContent(
                  context)), // Medya içeriği için yeni fonksiyon
          SizedBox(height: 16),

          Row(
            children: [
              Spacer(),
              IconButton(
                iconSize: 25,
                icon: postlikeIcon,
                color: postlikeColor,
                onPressed: () {
                  FunctionsPosts funct = FunctionsPosts();
                  funct.likeordislike(widget.postID);
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
                onPressed: () {
                  // FunctionsPosts funct = FunctionsPosts();
                  // funct.likeordislike(widget.postID);
                },
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
                onPressed: () {
                  FunctionsPosts funct = FunctionsPosts();
                  funct.likeordislike(widget.postID);
                },
              ), // Retweet simgesi (yeşil renkte)
              Spacer(),
              Icon(Icons.share_outlined,
                  color: Colors.grey), // Paylaşım simgesi
              Spacer(),
            ],
          )
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
      return Image.network(
        mediaUrl,
        fit: fit,
        width: width,
        height: height,
      );
    }

    Widget Mediayerlesim = Row();
    if (widget.mediaUrls.length == 1) {
      Mediayerlesim = Row(
        mainAxisAlignment: MainAxisAlignment
            .center, // Görüntülerin yatayda merkezlenmesini sağlar
        children: widget.mediaUrls.map((mediaUrl) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FullScreenImagePage(
                  images: widget.mediaUrls,
                  initialIndex: 0,
                ),
              ));
            },
            child: mediaSablon(mediaUrl,
                width: Screen.screenWidth / 1.09,
                height: Screen.screenHeight / 2),
          );
        }).toList(),
      );
    } else if (widget.mediaUrls.length == 2) {
      Mediayerlesim = Row(
        mainAxisAlignment: MainAxisAlignment
            .center, // Görüntülerin yatayda merkezlenmesini sağlar
        children: widget.mediaUrls.map((mediaUrl) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FullScreenImagePage(
                  images: widget.mediaUrls,
                  initialIndex: 0,
                ),
              ));
            },
            child: mediaSablon(mediaUrl,
                width: Screen.screenWidth / 2.18,
                height: Screen.screenHeight / 4),
          );
        }).toList(),
      );
    } else if (widget.mediaUrls.length == 3) {
      Mediayerlesim = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.mediaUrls.sublist(0, 1).map((mediaUrl) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      images: widget.mediaUrls,
                      initialIndex: 0,
                    ),
                  ));
                },
                child: mediaSablon(mediaUrl,
                    width: Screen.screenWidth / 1.09,
                    height: Screen.screenHeight / 2.5),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.mediaUrls.sublist(1, 3).map((mediaUrl) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      images: widget.mediaUrls,
                      initialIndex: 0,
                    ),
                  ));
                },
                child: mediaSablon(mediaUrl,
                    width: Screen.screenWidth / 2.18,
                    height: Screen.screenHeight / 4),
              );
            }).toList(),
          ),
        ],
      );
    } else if (widget.mediaUrls.length >= 4) {
      Mediayerlesim = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.mediaUrls.sublist(0, 2).map((mediaUrl) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      images: widget.mediaUrls,
                      initialIndex: 0,
                    ),
                  ));
                },
                child: mediaSablon(mediaUrl,
                    width: Screen.screenWidth / 2.19,
                    height: Screen.screenHeight / 4),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.mediaUrls.sublist(2, 4).map((mediaUrl) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      images: widget.mediaUrls,
                      initialIndex: 0,
                    ),
                  ));
                },
                child: mediaSablon(mediaUrl,
                    width: Screen.screenWidth / 2.19,
                    height: Screen.screenHeight / 4),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Mediayerlesim;
  }
}
