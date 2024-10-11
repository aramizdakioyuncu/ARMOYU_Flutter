import 'dart:developer';

import 'package:ARMOYU/app/widgets/text.dart';
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

  static void addhashtagList(Map<String, dynamic> newHashtag) {
    // Eklemeden önce listede aynı kişinin olup olmadığını kontrol et
    // Eğer hashtag listede yoksa ekle
    if (!hashtagList.any((hashtag) => hashtag['id'] == newHashtag['id'])) {
      hashtagList.add(newHashtag);
    } else {
      log("Hashtag zaten listede bulunmaktadır.");
    }
  }

  static Mention poplementions() {
    return Mention(
      trigger: '@',
      style: const TextStyle(color: Colors.amber),
      data: peopleList,
      matchAll: false,
      suggestionBuilder: (data) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  data['photo'],
                ),
              ),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText.costum1(data['full_name']),
                  Text(
                    '@${data['display']}',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
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
      style: const TextStyle(color: Colors.blue),
      matchAll: true,
      suggestionBuilder: (data) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText.costum1(
                  "#${data['display']} (${data["numberofuses"]})"),
              Text(
                "Gündemdekiler",
                style: TextStyle(color: Colors.black.withOpacity(0.7)),
              ),
            ],
          ),
        );
      },
      data: hashtagList,
    );
  }
}
