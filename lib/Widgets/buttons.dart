// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomButtons {
  Widget Costum1(
    String text,
    onPressed,
  ) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Arka plan rengini belirleyin
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
}
