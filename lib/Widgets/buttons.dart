import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Arka plan rengini belirleyin
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Kenar yarıçapını ayarlayın
        ),
      ),
      child: Text(text),
    );
  }
}
