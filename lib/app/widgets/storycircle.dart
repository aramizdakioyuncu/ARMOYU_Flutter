import 'package:ARMOYU/app/data/models/Story/storylist.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/modules/Story/screen_story_page/views/storyscreen_page.dart';
import 'package:ARMOYU/app/modules/Utility/galleryscreen_page.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetStorycircle extends StatefulWidget {
  final User currentUser;
  final List<StoryList> content;

  const WidgetStorycircle({
    super.key,
    required this.currentUser,
    required this.content,
  });

  @override
  State<WidgetStorycircle> createState() => _WidgetStorycircleState();
}

class _WidgetStorycircleState extends State<WidgetStorycircle> {
  @override
  void initState() {
    super.initState();
  }

  setstatefunction() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor,
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
                  if (cardData.owner.userID == widget.currentUser.userID) {
                    if (cardData.story != null) {
                      storycolor = Colors.blue;
                      ishasstory = true;
                    }
                  }
                  Color circleColor = Colors.transparent;
                  if (cardData.owner.userID == widget.currentUser.userID) {
                    circleColor = storycolor;
                  } else {
                    circleColor = otherstorycolor;
                  }

                  return GestureDetector(
                    onTap: () {
                      if (cardData.owner.userID == widget.currentUser.userID) {
                        if (ishasstory) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryScreenPage(
                                currentUser: widget.currentUser,
                                storyList: widget.content,
                                storyIndex: index,
                              ),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalleryScreen(
                              currentUser: widget.currentUser,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryScreenPage(
                              currentUser: widget.currentUser,
                              storyList: widget.content,
                              storyIndex: index,
                            ),
                          ),
                        );

                        //Basılınca görüntülendi efekti ver
                        widget.content[index].isView = true;
                        setstatefunction();
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
                              color: circleColor,
                              width: 3.0,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: CachedNetworkImageProvider(
                                cardData.owner.avatar!.mediaURL.minURL,
                              ),
                            ),
                          ),
                          child: cardData.owner.userID ==
                                  widget.currentUser.userID
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                      color: Get.theme.scaffoldBackgroundColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.elliptical(100, 100),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 2),
                        CustomText.costum1(
                          cardData.owner.userID == widget.currentUser.userID
                              ? "Hikayen"
                              : cardData.owner.userName!,
                          size: 11,
                        ),
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
