import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Screens/Profile/profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget specialText(BuildContext context, String text) {
  final lines = text.split('\n');
  final textSpans = <TextSpan>[];

  for (String line in lines) {
    final words = line.split(' ');
    final lineSpans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      if (word.isNotEmpty) {
        if (word.startsWith('#')) {
          final trimmedWord = word.trim();
          lineSpans.add(TextSpan(
            text: trimmedWord,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Burada # işaretine tıklandığında yapılacak işlemi ekleyin
                log('Tapped on hashtag: $trimmedWord');
              },
          ));
        } else if (word.startsWith('@')) {
          final username = word.trim(); // @ işaretini kaldır ve trim yap
          lineSpans.add(TextSpan(
            text: username,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Burada @ işaretine tıklandığında yapılacak işlemi ekleyin
                log('Tapped on username: $username');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        username: username.substring(1), appbar: true),
                  ),
                );
              },
          ));
        } else {
          lineSpans.add(TextSpan(
            text: word,
            style: TextStyle(color: ARMOYU.color),
          ));
        }

        if (i < words.length - 1) {
          lineSpans.add(const TextSpan(text: ' '));
        }
      }
    }

    textSpans.add(TextSpan(children: lineSpans));
    textSpans.add(const TextSpan(text: '\n'));
  }

  return RichText(
    text: TextSpan(children: textSpans),
  );
}
