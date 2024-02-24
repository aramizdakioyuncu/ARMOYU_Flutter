// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomSearchEngine {
  Widget costom1(BuildContext context, int userID, String displayname,
      String avatar, String date) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(userID: userID, appbar: true),
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 10 birimlik boşluk ekledik
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProfilePage(userID: userID, appbar: true),
                ));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors
                    .transparent, // Set a background color for the avatar if needed
                child: CachedNetworkImage(
                  imageUrl: avatar,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 40, // Set the width to twice the radius (2 * radius)
                    height:
                        40, // Set the height to twice the radius (2 * radius)
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // CustomDedectabletext().Costum1(text, 1, 15)
                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end, // Sağa yaslamak için
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chat(
      function, int userID, String displayname, String avatar, String date) {
    return InkWell(
      onTap: () {
        try {
          function();
        } catch (e) {}
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(avatar),
              radius: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayname,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ARMOYU.textColor,
                    ),
                  ),
                  // CustomDedectabletext().Costum1(text, 1, 15)
                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end, // Sağa yaslamak için
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: ARMOYU.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
