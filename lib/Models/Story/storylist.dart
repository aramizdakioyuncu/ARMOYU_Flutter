import 'package:ARMOYU/Models/Story/story.dart';

class StoryList {
  int ownerID;
  String ownerusername;
  String owneravatar;
  List<Story>? story;

  StoryList(
    this.ownerID,
    this.ownerusername,
    this.owneravatar,
    this.story,
  );

  // JSON'dan Story nesnesi oluşturmak için yardımcı bir metot
  factory StoryList.fromJson(Map<String, dynamic> json) {
    return StoryList(
      json['ownerID'] as int,
      json['ownerusername'] as String,
      json['owneravatar'] as String,
      json['story'] as List<Story>,
    );
  }

  // Story sınıfını bir JSON nesnesine dönüştürmek için yardımcı bir metot
  Map<String, dynamic> toJson() => {
        'ownerID': ownerID,
        'ownerusername': ownerusername,
        'owneravatar': owneravatar,
        'story': story,
      };
}
