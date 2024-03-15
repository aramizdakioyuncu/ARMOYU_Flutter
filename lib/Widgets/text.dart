import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomText {
  static Widget costum1(String text, {double? size, FontWeight? weight}) {
    return Text(
      text,
      style: TextStyle(
        color: ARMOYU.textColor,
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}
