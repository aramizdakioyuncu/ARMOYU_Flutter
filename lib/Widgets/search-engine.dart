// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ARMOYU/Screens/chatdetail_page.dart';
import 'package:ARMOYU/Screens/profile_page.dart';
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
                foregroundImage: CachedNetworkImageProvider(avatar),
                radius: 20,
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
        } catch (e) {
          print("Catche düştü:\n" + e.toString());
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(avatar),
                radius: 20,
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
}
