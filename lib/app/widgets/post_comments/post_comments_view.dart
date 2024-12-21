import 'package:ARMOYU/app/core/widgets.dart';
import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/Social/comment.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/services/accountuser_services.dart';
import 'package:ARMOYU/app/widgets/post_comments/post_comments_controller.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetPostComments extends StatelessWidget {
  final Comment comment;

  const WidgetPostComments({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostCommentsController(comment: comment));

    final findCurrentAccountController = Get.find<AccountUserController>();

    return Obx(
      () => Visibility(
        visible: controller.isvisiblecomment,
        child: ListTile(
          minLeadingWidth: 1.0,
          minVerticalPadding: 5.0,
          contentPadding: const EdgeInsets.all(0),
          leading: SizedBox(
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    PageFunctions functions = PageFunctions();
                    functions.pushProfilePage(
                      context,
                      User(userID: controller.xcomment!.value!.user.userID),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundImage: CachedNetworkImageProvider(
                      controller
                          .xcomment!.value!.user.avatar!.mediaURL.minURL.value,
                    ),
                    radius: 20,
                  ),
                ),
              ],
            ),
          ),
          title: Text(controller.xcomment!.value!.user.displayName!.value),
          subtitle: Text(controller.xcomment!.value!.content),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.likeunlikefunction();
                },
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      controller.favoritestatus,
                      const SizedBox(height: 3),
                      CustomText.costum1(
                        controller.xcomment!.value!.likeCount.toString(),
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: findCurrentAccountController
                          .currentUserAccounts.value.user.value.userID ==
                      controller.xcomment!.value!.user.userID,
                  child: IconButton(
                    onPressed: () async => ARMOYUWidget.showConfirmationDialog(
                      context,
                      accept: controller.removeComment,
                    ),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
