class Story {
  int storyID;
  int ownerID;
  String ownerusername;
  String owneravatar;
  String time;
  String media;
  int isLike;
  int isView;

  Story({
    required this.storyID,
    required this.ownerID,
    required this.ownerusername,
    required this.owneravatar,
    required this.time,
    required this.media,
    required this.isLike,
    required this.isView,
  });
}
