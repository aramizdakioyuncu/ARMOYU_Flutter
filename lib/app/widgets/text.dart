import 'package:ARMOYU/app/functions/page_functions.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomText {
  static Text costum1(
    String text, {
    double? size,
    FontWeight? weight,
    TextAlign align = TextAlign.left,
    Color? color,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
      textAlign: align,
    );
  }

  static Widget usercomments(
    BuildContext context, {
    required String text,
    required User user,
  }) {
    final textSpans = <InlineSpan>[];
    textSpans.add(
      TextSpan(
        children: [
          TextSpan(
            text: user.displayName!.value,
            style: TextStyle(
              color: Get.theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                PageFunctions functions = PageFunctions();
                functions.pushProfilePage(
                  context,
                  User(
                    userName: user.userName,
                  ),
                );
              },
          )
        ],
      ),
    );

    textSpans.add(
      TextSpan(
        text: " $text",
        style: TextStyle(
          color: Get.theme.primaryColor,
        ),
      ),
    );

    textSpans.insert(0, const WidgetSpan(child: SizedBox(width: 5)));
    textSpans.insert(
      0,
      WidgetSpan(
        child: InkWell(
          onTap: () {
            PageFunctions functions = PageFunctions();

            functions.pushProfilePage(
              context,
              User(userName: user.userName),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(
              user.avatar!.mediaURL.minURL.value,
            ),
            radius: 8,
          ),
        ),
      ),
    );
    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}
