import 'dart:developer';

import 'package:armoyu/app/translations/app_translation.dart';
import 'package:armoyu/app/widgets/text.dart';
import 'package:armoyu_widgets/data/models/Story/storylist.dart';
import 'package:armoyu_widgets/data/services/accountuser_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetStorycircle extends StatelessWidget {
  final RxList<StoryList> content;

  const WidgetStorycircle({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    //****//
    final findCurrentAccountController = Get.find<AccountUserController>();
    log("Current AccountUser :: ${findCurrentAccountController.currentUserAccounts.value.user.value.displayName}");
    //****//

    var currentUser =
        findCurrentAccountController.currentUserAccounts.value.user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
          child: SizedBox(
            height: 105,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: content.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final StoryList cardData = content[index];
                Color storycolor = Colors.transparent;
                Color otherstorycolor = Colors.red;

                if (cardData.isView) {
                  otherstorycolor = Colors.grey;
                }

                bool ishasstory = false;
                if (cardData.owner.userID == currentUser.value.userID) {
                  if (cardData.story != null) {
                    storycolor = Colors.blue;
                    ishasstory = true;
                  }
                }
                Color circleColor = Colors.transparent;
                if (cardData.owner.userID == currentUser.value.userID) {
                  circleColor = storycolor;
                } else {
                  circleColor = otherstorycolor;
                }

                return GestureDetector(
                  onTap: () {
                    if (cardData.owner.userID == currentUser.value.userID) {
                      if (ishasstory) {
                        Get.toNamed("/story", arguments: {
                          "storyList": content,
                          "storyIndex": index,
                        });

                        return;
                      }

                      Get.toNamed("/gallery");
                    } else {
                      Get.toNamed("/story/screen", arguments: {
                        "storyList": content,
                        "storyIndex": index,
                      });

                      //Basılınca görüntülendi efekti ver
                      content[index].isView = true;
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
                              cardData.owner.avatar!.mediaURL.minURL.value,
                            ),
                          ),
                        ),
                        child: cardData.owner.userID == currentUser.value.userID
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
                        cardData.owner.userID == currentUser.value.userID
                            ? SocialKeys.socialStory.tr
                            : cardData.owner.userName!.value,
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
    );
  }
}
