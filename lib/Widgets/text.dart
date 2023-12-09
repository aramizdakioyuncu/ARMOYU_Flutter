// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomText {
  Widget Costum1(String text, {double? size, FontWeight? weight}) {
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
