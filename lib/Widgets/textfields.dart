import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:flutter/material.dart';

class CustomTextfields {
  static TextField costum3(
    text, {
    required TextEditingController controller,
    bool? isPassword,
    Icon? preicon,
    IconButton? suffixiconbutton,
    TextInputType? type,
    Function(String)? onChanged,
    int? maxLength,
  }) {
    return TextField(
      onChanged: (value) {
        if (onChanged == null) {
          return;
        }
        onChanged(value);
      },
      controller: controller,

      //sadece isim için olunca @ ! gibi işaretler olmuyor
      keyboardType: type,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      obscureText: isPassword!,
      maxLength: maxLength,
      style: TextStyle(color: ARMOYU.textColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16.0),

        suffixIcon: suffixiconbutton,
        counterText: "", //Maxlength yazısını gizle
        suffixText:
            maxLength == null ? null : "${controller.text.length}/$maxLength",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide.none,
        ),
        prefixIcon: preicon,
        prefixIconColor: ARMOYU.textColor,
        hintText: text,
        hintStyle: TextStyle(
          color: ARMOYU.texthintColor,
        ),
        filled: true,
        fillColor: ARMOYU.textbackColor,
      ),
    );
  }

  static TextField number(
    String text, {
    required TextEditingController controller,
    required int length,
    required Icon icon,
  }) {
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
        contentPadding: const EdgeInsets.all(8.0),
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
