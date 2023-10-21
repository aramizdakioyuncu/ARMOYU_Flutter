// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TwitterPostWidget extends StatelessWidget {
  final String profileImageUrl;
  final String username;
  final String postText;
  final String postDate;
  final List<String> mediaUrls;
  final String postlikeCount;
  final String postcommentCount;

  TwitterPostWidget({
    required this.profileImageUrl,
    required this.username,
    required this.postText,
    required this.postDate,
    required this.mediaUrls,
    required this.postlikeCount,
    required this.postcommentCount,
  });

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: 30,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    postDate,
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
          _buildMediaContent(), // Medya içeriği için yeni fonksiyon
          SizedBox(height: 16),

          Row(
            children: [
              Spacer(),
              Icon(Icons.favorite_outline, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                postlikeCount,
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(),
              Icon(Icons.comment_outlined, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                postcommentCount,
                style: TextStyle(color: Colors.grey),
              ), // Yorum simgesi
              Spacer(),
              Icon(Icons.recycling_outlined,
                  color: Colors.grey), // Retweet simgesi (yeşil renkte)
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
    final words = postText.split(' ');

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

  Widget _buildMediaContent() {
    return Column(
      children: mediaUrls.map((mediaUrl) {
        return Image.network(
            mediaUrl); // Medya içeriğini görüntülemek için Image widget'ını kullanın
      }).toList(),
    );
  }
}
