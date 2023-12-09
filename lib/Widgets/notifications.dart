// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomNotifications {
  static void stackbarNotification(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ARMOYU.bacgroundcolor,
        content: Text(
          text,
          style: TextStyle(color: ARMOYU.textColor),
        ),
        duration: Duration(milliseconds: 500),
      ),
    );
  }
}
