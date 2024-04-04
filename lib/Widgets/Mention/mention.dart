import 'dart:developer';

import 'package:ARMOYU/Core/ARMOYU.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class WidgetMention {
  static List<Map<String, dynamic>> peopleList = [];
  static List<Map<String, dynamic>> hashtagList = [];

  static void addpeopleList(Map<String, dynamic> newPerson) {
    // Eklemeden önce listede aynı kişinin olup olmadığını kontrol et

    // Eğer kişi listede yoksa ekle
    if (!peopleList.any((person) => person['id'] == newPerson['id'])) {
      peopleList.add(newPerson);
    } else {
      log("Kişi zaten listede bulunmaktadır.");
    }
  }

  static Mention poplementions() {
    return Mention(
      trigger: '@',
      style: const TextStyle(
        color: Colors.amber,
      ),
      data: peopleList,
      matchAll: false,
      suggestionBuilder: (data) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: ARMOYU.appbarColor,
            border: const Border.symmetric(
              horizontal: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  data['photo'],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data['full_name']),
                  Text('@${data['display']}'),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static Mention hashtag() {
    return Mention(
      trigger: '#',
      disableMarkup: true,
      style: const TextStyle(
        color: Colors.blue,
      ),
      data: [
        {'id': 'reactjs', 'display': 'reactjs'},
        {'id': 'javascript', 'display': 'javascript'},
      ],
      matchAll: true,
    );
  }
}
