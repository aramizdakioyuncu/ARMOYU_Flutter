// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, camel_case_types, non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Story/storylist.dart';
import 'package:ARMOYU/Screens/Utility/galleryscreen_page.dart';
import 'package:ARMOYU/Screens/Story/storyscreen_page.dart';
import 'package:ARMOYU/Services/User.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Widget_Storycircle extends StatefulWidget {
  final List<StoryList> content;

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
      color: ARMOYU.bacgroundcolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            child: SizedBox(
              height: 105,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.content.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final StoryList cardData = widget.content[index];
                  Color storycolor = Colors.transparent;
                  bool ishasstory = false;
                  if (cardData.ownerID == User.ID) {
                    if (cardData.story != null) {
                      storycolor = Colors.blue;
                      ishasstory = true;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      if (cardData.ownerID == User.ID) {
                        if (ishasstory) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StoryScreenPage(story: cardData.story!),
                            ),
                          );
                          return;
                        }
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
                            builder: (context) =>
                                StoryScreenPage(story: cardData.story!),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cardData.ownerID == User.ID
                                  ? storycolor
                                  : Colors.green, // Kenarlık rengi
                              width: 3.0, // Kenarlık kalınlığı
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: CachedNetworkImageProvider(
                                cardData.owneravatar,
                              ),
                            ),
                          ),
                          child: cardData.ownerID == User.ID
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
                        SizedBox(height: 2),
                        CustomText().Costum1(
                            cardData.ownerID == User.ID
                                ? "Hikayen"
                                : cardData.ownerusername,
                            size: 11),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
