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

  // Story nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'storyID': storyID,
      'ownerID': ownerID,
      'ownerusername': ownerusername,
      'owneravatar': owneravatar,
      'time': time,
      'media': media,
      'isLike': isLike,
      'isView': isView,
    };
  }

  // JSON'dan Story nesnesine dönüşüm
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      storyID: json['storyID'],
      ownerID: json['ownerID'],
      ownerusername: json['ownerusername'],
      owneravatar: json['owneravatar'],
      time: json['time'],
      media: json['media'],
      isLike: json['isLike'],
      isView: json['isView'],
    );
  }
}
