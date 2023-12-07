// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:ARMOYU/Core/app_core.dart';
import 'package:flutter/material.dart';

class CustomTextfields {
  Widget Costum1(String text, TextEditingController controller, bool isPassword,
      Icon icon) {
    return TextField(
      controller: controller,
      //sadece isim için olunca @ ! gibi işaretler olmuyor
      // keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        prefixIcon: icon,
        prefixIconColor: AppCore.textColor,
        hintText: text,
        hintStyle: TextStyle(
          color: AppCore.texthintColor,
        ),
        filled: true,
        fillColor: AppCore.textbackColor,
      ),
    );
  }

  Widget number(
    String text,
    TextEditingController controller,
    int length,
    Icon icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: length,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        counterText: "", //Limiti gizler
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
    );
  }
}
