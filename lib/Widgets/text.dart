import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Models/user.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
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

  static RichText usercomments(BuildContext context,
      {required String text, required User user}) {
    final textSpans = <TextSpan>[];
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
                // Burada # işaretine tıklandığında yapılacak işlemi ekleyin
                log('Tapped on : "${user.displayName}"');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      scrollController: ScrollController(),
                      appbar: true,
                      username: user.displayName,
                    ),
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
          color: ARMOYU.textColor,
        ),
      ),
    );

    return RichText(text: TextSpan(children: textSpans));
  }
}
