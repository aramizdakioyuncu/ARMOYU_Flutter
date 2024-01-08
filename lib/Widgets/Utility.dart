// ignore_for_file: file_names, avoid_print

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget specialText(context, String text) {
  final words = text.split(' ');

  final textSpans = words.map((word) {
    if (word.startsWith('#')) {
      return TextSpan(
        text: word + ' ',
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Burada # işaretine tıklandığında yapılacak işlemi ekleyin
            print('Tapped on hashtag: $word');
          },
      );
    }

    if (word.startsWith('@')) {
      return TextSpan(
        text: word + ' ',
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Burada @ işaretine tıklandığında yapılacak işlemi ekleyin
            print('Tapped on hashtag: $word');

            List getusername = word.split('@');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(username: getusername[1], appbar: true),
              ),
            );
          },
      );
    }
    return TextSpan(text: word + ' ', style: TextStyle(color: ARMOYU.color));
  }).toList();

  return RichText(
    text: TextSpan(
      children: textSpans,
    ),
  );
}
