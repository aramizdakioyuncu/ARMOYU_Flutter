import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/page_functions.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomText {
  static Text costum1(
    String text, {
    double? size,
    FontWeight? weight,
    TextAlign align = TextAlign.left,
    Color color = Colors.white70,
  }) {
    if (color == Colors.white70) {
      color = ARMOYU.textColor;
    }
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

  static Widget usercomments(BuildContext context,
      {required String text, required User user}) {
    final textSpans = <InlineSpan>[];
    textSpans.add(
      TextSpan(
        children: [
          TextSpan(
            text: user.displayName,
            style: TextStyle(
              color: ARMOYU.textColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                PageFunctions.pushProfilePage(
                  context,
                  User(
                    userName: user.userName,
                  ),
                  ScrollController(),
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
          color: ARMOYU.textColor,
        ),
      ),
    );

    textSpans.insert(0, const WidgetSpan(child: SizedBox(width: 5)));
    textSpans.insert(
      0,
      WidgetSpan(
        child: InkWell(
          onTap: () {
            PageFunctions.pushProfilePage(
              context,
              User(
                userName: user.userName,
              ),
              ScrollController(),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(
              user.avatar!.mediaURL.minURL,
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
