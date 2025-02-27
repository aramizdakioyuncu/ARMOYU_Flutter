import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get.dart';

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
        return Material(
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            enableFeedback: true,
            leading: CircleAvatar(
              foregroundImage: CachedNetworkImageProvider(data['photo']),
            ),
            title: Text(data['full_name']),
            subtitle: Text(
              "@${data['display']}",
              style: TextStyle(
                color: Get.theme.primaryColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        );
      },
    );
  }

  static Mention hashtag() {
    return Mention(
      trigger: '#',
      style: const TextStyle(color: Colors.blue),
      data: hashtagList,
      matchAll: false,
      suggestionBuilder: (data) {
        return ListTile(
          title: Text("#${data['display']} (${data["numberofuses"]})"),
          subtitle: Text(
            "Gündemdekiler",
            style: TextStyle(
              color: Get.theme.primaryColor.withValues(alpha: 0.7),
            ),
          ),
        );
      },
    );
  }
}
