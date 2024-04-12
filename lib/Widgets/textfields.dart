import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:ARMOYU/Functions/API_Functions/search.dart';
import 'package:ARMOYU/Widgets/Mention/mention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class CustomTextfields {
  static Timer? searchTimer;

  static Widget costum3(
    text, {
    required TextEditingController controller,
    bool isPassword = false,
    Icon? preicon,
    IconButton? suffixiconbutton,
    TextInputType? type,
    Function(String)? onChanged,
    Function? onTap,
    int? maxLength,
    bool? enabled = true,
    int? maxLines = 1,
    int? minLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        onTap: () {
          if (onTap == null) {
            return;
          }
          onTap();
        },
        onChanged: (value) {
          if (onChanged == null) {
            return;
          }
          onChanged(value);
        },
        minLines: minLines,
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: type,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.username],
        obscureText: isPassword,
        maxLength: maxLength,
        style: TextStyle(color: ARMOYU.textColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          suffixIcon: suffixiconbutton,
          counterText: "", //Maxlength yazısını gizle
          suffixText:
              maxLength == null ? null : "${controller.text.length}/$maxLength",
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          prefixIcon: preicon,
          prefixIconColor: ARMOYU.textColor,
          hintText: text,
          hintStyle: TextStyle(color: ARMOYU.texthintColor),
          filled: true,
          fillColor: ARMOYU.textbackColor,
        ),
      ),
    );
  }

  static mentionTextFiled({
    required key,
    required Function setstate,
    int? minLines = 1,
  }) {
    return FlutterMentions(
      key: key,
      suggestionPosition: SuggestionPosition.Top,
      maxLines: 20,
      minLines: minLines,
      suggestionListDecoration: BoxDecoration(color: ARMOYU.appbarColor),
      suggestionListHeight: ARMOYU.screenHeight / 3,
      onChanged: (value) {
        List<String> words = value.split(' ');
        final String lastWord = words.isNotEmpty ? words.last : "";

        if (lastWord.isEmpty) {
          // Eğer son kelime boşsa, mevcut sorguyu iptal eder
          searchTimer?.cancel();
          return;
        }

        //Oyuncu listesi bomboşsa
        if (WidgetMention.peopleList.isEmpty) {
          searchTimer = Timer(const Duration(milliseconds: 500), () async {
            FunctionsSearchEngine f = FunctionsSearchEngine();
            Map<String, dynamic> response = await f.onlyusers("", 1);
            if (response["durum"] == 0) {
              log(response["aciklama"]);
              return;
            }
            for (var element in response["icerik"]) {
              WidgetMention.addpeopleList({
                'id': element["ID"].toString(),
                'display': element["username"].toString(),
                'full_name': element["Value"].toString(),
                'photo': element["avatar"].toString()
              });
            }
            setstate();
          });
        }
        //Hashtag listesi bomboşsa
        if (WidgetMention.hashtagList.isEmpty) {
          searchTimer = Timer(const Duration(milliseconds: 500), () async {
            FunctionsSearchEngine f = FunctionsSearchEngine();
            Map<String, dynamic> response = await f.hashtag("", 1);
            if (response["durum"] == 0) {
              log(response["aciklama"]);
              return;
            }
            for (var element in response["icerik"]) {
              WidgetMention.addhashtagList({
                'id': element["hashtag_ID"].toString(),
                'display': element["hashtag_value"].toString(),
                'numberofuses': element["hashtag_numberofuses"],
              });
            }
            setstate();
          });
        }

        if (lastWord.length <= 3) {
          return;
        }

        if (lastWord[0] != "@" && lastWord[0] != "#") {
          // Eğer son kelime @ veya # ile başlamıyorsa, mevcut sorguyu iptal eder
          searchTimer?.cancel();
          return;
        }

        // Eğer buraya kadar gelindi ise, yeni bir kelime girilmiştir, mevcut sorguyu iptal eder
        searchTimer?.cancel();
        searchTimer = Timer(const Duration(milliseconds: 500), () async {
          FunctionsSearchEngine f = FunctionsSearchEngine();

          Map<String, dynamic> response;
          if (lastWord[0] == "@") {
            response = await f.onlyusers(lastWord.substring(1), 1);
          } else if (lastWord[0] == "#") {
            response = await f.hashtag(lastWord.substring(1), 1);
          } else {
            return;
          }

          if (response["durum"] == 0) {
            log(response["aciklama"]);
            return;
          }
          for (var element in response["icerik"]) {
            if (lastWord[0] == "@") {
              WidgetMention.addpeopleList({
                'id': element["ID"].toString(),
                'display': element["username"].toString(),
                'full_name': element["Value"].toString(),
                'photo': element["avatar"].toString()
              });
            }
            if (lastWord[0] == "#") {
              WidgetMention.addhashtagList({
                'id': element["hashtag_ID"].toString(),
                'display': element["hashtag_value"].toString(),
                'numberofuses': element["hashtag_numberofuses"],
              });
            }
          }

          setstate();
        });
      },
      decoration: const InputDecoration(hintText: 'Bir şeyler yaz'),
      mentions: [
        WidgetMention.poplementions(),
        WidgetMention.hashtag(),
      ],
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
