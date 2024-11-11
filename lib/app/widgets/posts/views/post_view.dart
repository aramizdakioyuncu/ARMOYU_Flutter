import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/Social/post.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/data/models/useraccounts.dart';
import 'package:ARMOYU/app/translations/app_translation.dart';
import 'package:ARMOYU/app/widgets/posts/controllers/post_controller.dart';
import 'package:ARMOYU/app/widgets/utility.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class TwitterPostWidget extends StatelessWidget {
  final UserAccounts currentUserAccounts;
  final Post post;
  final bool? isPostdetail = false;

  const TwitterPostWidget({
    super.key,
    required this.currentUserAccounts,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    String uniqueTag = DateTime.now().millisecondsSinceEpoch.toString();

    final controller = Get.put(
      PostController(
        currentUserAccounts: currentUserAccounts,
        post: post,
      ),
      tag:
          "${currentUserAccounts.user.value.userID}postUniq${post.postID}-$uniqueTag",
    );

    return Obx(
      () => Visibility(
        visible: controller.postVisible.value,
        child: Container(
          margin: const EdgeInsets.only(bottom: 1),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: InkWell(
                  onTap: () {
                    PageFunctions functions = PageFunctions(
                      currentUserAccounts: currentUserAccounts,
                    );

                    functions.pushProfilePage(
                      context,
                      User(
                        userID: post.owner.userID,
                      ),
                      ScrollController(),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: CachedNetworkImageProvider(
                            controller.postInfo.value.owner.avatar!.mediaURL
                                .minURL.value,
                          ),
                          radius: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => CustomText.costum1(
                                    controller.postInfo.value.owner.userName!,
                                    size: 16,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () =>
                                      controller.postInfo.value.sharedDevice ==
                                              "mobil"
                                          ? const Text("📱")
                                          : const Text("🌐"),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () => CustomText.costum1(
                                    controller.postInfo.value.postDate
                                        .replaceAll(
                                            'Saniye', CommonKeys.second.tr)
                                        .replaceAll(
                                            'Dakika', CommonKeys.minute.tr)
                                        .replaceAll('Saat', CommonKeys.hour.tr)
                                        .replaceAll('Gün', CommonKeys.day.tr)
                                        .replaceAll('Ay', CommonKeys.month.tr)
                                        .replaceAll('Yıl', CommonKeys.year.tr),
                                    weight: FontWeight.normal,
                                    color: Get.theme.primaryColor
                                        .withOpacity(0.69),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => Visibility(
                                    visible:
                                        controller.postInfo.value.location !=
                                            null,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 1),
                                        CustomText.costum1(
                                          controller.postInfo.value.location
                                              .toString(),
                                          weight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: controller.postfeedback,
                            icon: const Icon(Icons.more_vert),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onDoubleTap: () {
                  if (!controller.postInfo.value.isLikeme) {
                    // controller.likeButtonKey.value.currentState?.onTap();
                    controller.postLike(controller.postInfo.value.isLikeme);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: WidgetUtility.specialText(
                            context,
                            currentUserAccounts: currentUserAccounts,
                            controller.postInfo.value.content,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onDoubleTap: () {
                  if (!controller.postInfo.value.isLikeme) {
                    // controller.likeButtonKey.value.currentState?.onTap();
                  }
                },
                child: Obx(
                  () => Center(
                    child: controller.buildMediaContent(context),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  children: [
                    InkWell(
                      onLongPress: () {
                        if (isPostdetail == false) {
                          controller.postcommentlikeslist();
                        }
                      },
                      child: Obx(
                        () => controller.likebutton.value!,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => IconButton(
                        iconSize: 25,
                        icon: controller.postcommentIcon.value,
                        color: controller.postcommentColor.value,
                        onPressed: () => controller
                            .postcomments(controller.postInfo.value.postID),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Obx(
                      () => Text(
                        controller.postInfo.value.commentsCount.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => IconButton(
                        iconSize: 25,
                        icon: controller.postrepostIcon.value,
                        color: controller.postrepostColor.value,
                        onPressed: () {},
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        await Share.share(
                          'https://aramizdakioyuncu.com/?sosyal1=${post.postID}',
                        );
                      },
                      icon: const Icon(Icons.share_outlined),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          const SizedBox(height: 20),
                          ...List.generate(
                              controller.postInfo.value.firstthreelike.length,
                              (index) {
                            int left = controller
                                        .postInfo.value.firstthreelike.length *
                                    10 -
                                (index + 1) * 10;
                            return Obx(
                              () => Positioned(
                                left: double.parse(left.toString()),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(
                                    post
                                        .firstthreelike[controller.postInfo
                                                .value.firstthreelike.length -
                                            index -
                                            1]
                                        .user
                                        .avatar!
                                        .mediaURL
                                        .minURL
                                        .value,
                                  ),
                                  radius: 10,
                                ),
                              ),
                            );
                          }),
                          Obx(
                            () => Positioned(
                              left: controller.postInfo.value.firstthreelike
                                          .length *
                                      10 +
                                  15,
                              child: controller
                                      .postInfo.value.firstthreelike.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () =>
                                          controller.postcommentlikeslist(),
                                      child: Obx(
                                        () => WidgetUtility.specialText(
                                          context,
                                          currentUserAccounts:
                                              currentUserAccounts,
                                          "@${controller.postInfo.value.firstthreelike[0].user.userName.toString()}  ${(controller.postInfo.value.likesCount - 1) == 0 ? SocialKeys.socialLiked.tr : SocialKeys.socialandnumberpersonLiked.tr.replaceAll('#NUMBER#', "${controller.postInfo.value.likesCount - 1}")}",
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Column(
                        children: List.generate(
                            controller.postInfo.value.firstthreecomment.length,
                            (index) {
                          return controller
                              .postInfo.value.firstthreecomment[index]
                              .commentlist(
                            context,
                            () {},
                            currentUserAccounts: currentUserAccounts,
                          );
                        }),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.postInfo.value.commentsCount > 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => controller
                                .postcomments(controller.postInfo.value.postID),
                            child: CustomText.costum1(
                              "${controller.postInfo.value.commentsCount} ${SocialKeys.socialViewAllComments.tr}",
                              color: Get.theme.primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
