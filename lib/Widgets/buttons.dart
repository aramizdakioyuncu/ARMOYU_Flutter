// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomButtons {
  Widget friendbuttons(String text, onPressed, Color color) {
    Color background = color;
    Color foregroundColor = Colors.white;
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: background, // Arka plan rengini belirleyin
        foregroundColor: foregroundColor,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Kenar yarıçapını ayarlayın
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget Costum1(String text, onPressed, bool loadingStatus) {
    Color? background = ARMOYU.buttonColor;

    if (loadingStatus) {
      background = Colors.transparent;
    }
    Color foregroundColor = Colors.white;
    return Column(
      children: [
        Visibility(
          visible: !loadingStatus,
          child: ElevatedButton(
            onPressed: () {
              if (!loadingStatus) {
                onPressed();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: background, // Arka plan rengini belirleyin
              foregroundColor: foregroundColor,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10), // Kenar yarıçapını ayarlayın
              ),
            ),
            child: Text(text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        Visibility(
          visible: loadingStatus,
          child: Column(
            children: [
              CircularProgressIndicator(
                color: Colors.red,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget Costum2(Icon icon, String text, onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[icon, SizedBox(width: 10), Text(text)],
      ),
    );
  }
}
