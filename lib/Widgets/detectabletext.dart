// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:developer';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';

class CustomDedectabletext {
  Widget Costum1(String text, int trimlines, double textsize) {
    return DetectableText(
      trimLines: trimlines,
      colorClickableText: Colors.pink,
      trimMode: TrimMode.Line,
      trimCollapsedText: ' Daha fazla',
      trimExpandedText: ' Daha az',
      text: text,
      detectionRegExp: RegExp(
        "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
        multiLine: true,
      ),
      callback: (bool readMore) {
        debugPrint('Read more >>>>>>> $readMore');
      },
      onTap: (tappedText) async {
        log(tappedText);
        if (tappedText.startsWith('#')) {
          debugPrint('DetectableText >>>>>>> #');
        } else if (tappedText.startsWith('@')) {
          debugPrint('DetectableText >>>>>>> @');
        } else if (tappedText.startsWith('http')) {
          debugPrint('DetectableText >>>>>>> http');
        }
      },
      basicStyle: TextStyle(
        fontSize: textsize,
        fontWeight: FontWeight.w400,
      ),
      detectedStyle: TextStyle(
        fontSize: textsize,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: Colors.blueAccent,
      ),
      lessStyle: TextStyle(color: Colors.grey),
      moreStyle: TextStyle(color: Colors.grey),
    );
  }
}
