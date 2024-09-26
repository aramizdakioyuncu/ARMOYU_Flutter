import 'package:ARMOYU/app/data/models/Story/story.dart';
import 'package:ARMOYU/app/data/models/user.dart';

class StoryList {
  User owner;
  List<Story>? story;
  bool isView;

  StoryList({
    required this.owner,
    required this.story,
    required this.isView,
  });

// StoryList nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'owner': owner.toJson(),
      'story': story?.map((s) => s.toJson()).toList(),
      'isView': isView,
    };
  }

  // JSON'dan StoryList nesnesine dönüşüm
  factory StoryList.fromJson(Map<String, dynamic> json) {
    return StoryList(
      owner: User.fromJson(json['owner']),
      story: json['story'] != null
          ? (json['story'] as List<dynamic>)
              .map((s) => Story.fromJson(s))
              .toList()
          : null,
      isView: json['isView'],
    );
  }
}
