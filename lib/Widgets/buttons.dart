// ignore_for_file: prefer_const_constructors

import 'package:ARMOYU/Core/screen.dart';
import 'package:flutter/material.dart';

class CustomButtons {
  Widget Costum1(
    String text,
    onPressed,
  ) {
    return Container(
      width: Screen.screenWidth / 2,
      height: Screen.screenHeight / 15,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Arka plan rengini belirleyin
          foregroundColor: Colors.black,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Kenar yarıçapını ayarlayın
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Widget Costum2(
    String text,
    onPressed,
  ) {
    return Container(
      width: 250,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Arka plan rengini belirleyin
          foregroundColor: Colors.black,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Kenar yarıçapını ayarlayın
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
