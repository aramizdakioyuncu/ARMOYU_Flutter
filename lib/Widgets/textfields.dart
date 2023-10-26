// ignore_for_file: prefer_const_constructors

import 'package:ARMOYU/Core/screen.dart';
import 'package:flutter/material.dart';

class CustomTextfields {
  Widget Costum1(String text, TextEditingController controller, bool isPassword,
      Icon icon) {
    return Container(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.username],
        obscureText: isPassword,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          prefixIcon: icon,
          prefixIconColor: Colors.white,
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
      ),
    );
  }
}
