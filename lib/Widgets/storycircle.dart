// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Utility/GalleryScreen.dart';
import 'package:ARMOYU/Screens/Utility/StoryScreen_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Widget_Storycircle extends StatefulWidget {
  final List content;

  Widget_Storycircle({
    required this.content,
  });

  @override
  State<Widget_Storycircle> createState() => _Widget_StorycircleState();
}

class _Widget_StorycircleState extends State<Widget_Storycircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ARMOYU.bodyColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            child: SizedBox(
              height: 97,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.content.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final cardData = widget.content[index];
                  return GestureDetector(
                    onTap: () {
                      if (cardData["userID"]! == User.ID.toString()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalleryScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryScreenPage(
                              images: [cardData["image"]!],
                              initialIndex: 0,
                            ),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cardData["userID"]! == User.ID.toString()
                                  ? Colors.transparent
                                  : Colors.green, // Kenarlık rengi
                              width: 3.0, // Kenarlık kalınlığı
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: CachedNetworkImageProvider(
                                cardData["image"]!,
                              ),
                            ),
                          ),
                          child: cardData["userID"]! == User.ID.toString()
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(100, 100))),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        Visibility(
                          visible: cardData["userID"]! != User.ID.toString(),
                          child: CustomText()
                              .Costum1(cardData["username"]!, size: 12),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
