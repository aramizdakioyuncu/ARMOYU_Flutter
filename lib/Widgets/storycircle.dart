import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/Story/storylist.dart';
import 'package:ARMOYU/Screens/Utility/galleryscreen_page.dart';
import 'package:ARMOYU/Screens/Story/storyscreen_page.dart';
import 'package:ARMOYU/Services/appuser.dart';
import 'package:ARMOYU/Widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WidgetStorycircle extends StatefulWidget {
  final List<StoryList> content;

  const WidgetStorycircle({
    super.key,
    required this.content,
  });

  @override
  State<WidgetStorycircle> createState() => _WidgetStorycircleState();
}

class _WidgetStorycircleState extends State<WidgetStorycircle> {
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
                  Color otherstorycolor = Colors.red;

                  if (cardData.isView) {
                    otherstorycolor = Colors.grey;
                  }

                  bool ishasstory = false;
                  if (cardData.ownerID == AppUser.ID) {
                    if (cardData.story != null) {
                      storycolor = Colors.blue;
                      ishasstory = true;
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      if (cardData.ownerID == AppUser.ID) {
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
                            builder: (context) => const GalleryScreen(),
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
                              color: cardData.ownerID == AppUser.ID
                                  ? storycolor
                                  : otherstorycolor, // Kenarlık rengi
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
                          child: cardData.ownerID == AppUser.ID
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(100, 100))),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 2),
                        CustomText().costum1(
                            cardData.ownerID == AppUser.ID
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
