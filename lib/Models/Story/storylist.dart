import 'package:ARMOYU/Models/Story/story.dart';

class StoryList {
  int ownerID;
  String ownerusername;
  String owneravatar;
  List<Story>? story;
  bool isView;

  StoryList({
    required this.ownerID,
    required this.ownerusername,
    required this.owneravatar,
    required this.story,
    required this.isView,
  });
}
