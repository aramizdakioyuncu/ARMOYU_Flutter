// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomButtons {
  Widget Costum1(String text, onPressed) {
    Color background = Colors.white;
    return Container(
      child: ElevatedButton(
        onPressed: () {
          onPressed();
          background = Colors.grey;
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: background, // Arka plan rengini belirleyin
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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

  Widget Costum2(Icon icon, String text, onPressed) {
    return Container(
      child: ElevatedButton(
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
      ),
    );
  }
}
