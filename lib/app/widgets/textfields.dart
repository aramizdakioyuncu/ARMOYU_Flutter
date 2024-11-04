import 'dart:async';
import 'dart:developer';

import 'package:ARMOYU/app/core/ARMOYU.dart';
import 'package:ARMOYU/app/functions/API_Functions/search.dart';
import 'package:ARMOYU/app/data/models/user.dart';
import 'package:ARMOYU/app/widgets/Mention/mention.dart';
import 'package:ARMOYU/app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:get/get.dart';

class CustomTextfields {
  static Widget costum3({
    String? title,
    required TextEditingController controller,
    bool isPassword = false,
    String? placeholder,
    Icon? preicon,
    IconButton? suffixiconbutton,
    TextInputType? type,
    Function(String)? onChanged,
    Function? onTap,
    int? maxLength,
    int? minLength,
    bool? enabled = true,
    int? maxLines,
    int? minLines = 1,
    FocusNode? focusNode,
  }) {
    if (minLines != null) {
      maxLines = minLines + 5;
    }

    if (title != null) {
      placeholder = title;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CustomText.costum1(title.toString()),
          ),
        ),
        TextField(
          onTap: () {
            if (onTap == null) {
              return;
            }
            onTap();
          },
          onChanged: (value) {
            // setstate();
            if (onChanged != null) {
              onChanged(value);
            }

            if (!isPassword && maxLength != null) {
              if (value.length >= maxLength) {
                return;
              }
            }
          },
          focusNode: focusNode,
          enabled: enabled,
          controller: controller,
          obscureText: isPassword,
          minLines: minLines,
          maxLines: !isPassword ? maxLines : 1,
          maxLength: maxLength,
          keyboardType: type,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            suffixIcon: suffixiconbutton,
            counter: minLength != null || maxLength != null
                ? minLength != null && controller.text.length < minLength
                    ? Text(
                        "${controller.text.length}/${controller.text.length <= minLength ? minLength : minLength}",
                        style: TextStyle(
                          color: controller.text.length < minLength
                              ? Colors.red
                              : Colors.grey,
                        ),
                      )
                    : maxLength != null
                        ? Text(
                            "${controller.text.length}/${controller.text.length >= maxLength ? maxLength : maxLength}",
                            style: TextStyle(
                              color: controller.text.length == maxLength
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          )
                        : null
                : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide.none,
            ),
            prefixIcon: preicon,
            hintText: placeholder,
            filled: true,
          ),
        ),
      ],
    );
  }

  static FlutterMentions mentionTextFiled({
    required Rx<GlobalKey<FlutterMentionsState>> key,
    int? minLines = 1,
    required User currentUser,
    Timer? searchTimer,
  }) {
    return FlutterMentions(
      key: key.value,
      suggestionPosition: SuggestionPosition.Top,
      maxLines: 20,
      minLines: minLines,
      suggestionListDecoration: const BoxDecoration(color: Colors.black),
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
            FunctionsSearchEngine f =
                FunctionsSearchEngine(currentUser: currentUser);
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
            // setstate();
            key.refresh();
          });
        }
        //Hashtag listesi bomboşsa
        if (WidgetMention.hashtagList.isEmpty) {
          searchTimer = Timer(const Duration(milliseconds: 500), () async {
            FunctionsSearchEngine f =
                FunctionsSearchEngine(currentUser: currentUser);
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
            // setstate();
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
          FunctionsSearchEngine f =
              FunctionsSearchEngine(currentUser: currentUser);

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

          // setstate();
        });
      },
      decoration: const InputDecoration(hintText: 'Bir şeyler yaz'),
      mentions: [
        WidgetMention.poplementions(),
        WidgetMention.hashtag(),
      ],
    );
  }

  static TextField number({
    String? placeholder,
    required TextEditingController controller,
    required int length,
    required Icon icon,
    String? category,
  }) {
    List<TextInputFormatter>? formatter;
    if (category.toString() == "phoneNumber") {
      length = 15;
      formatter = [MaskedInputFormatter('(###) ### ## ##')];
    }

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: length,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      style: const TextStyle(color: Colors.white),
      inputFormatters: formatter,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        counterText: "", //Limiti gizler
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        prefixIcon: icon,
        prefixIconColor: Colors.white,
        hintText: placeholder,

        filled: true,
      ),
    );
  }
}
