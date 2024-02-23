class Story {
  int storyID;
  int ownerID;
  String ownerusername;
  String owneravatar;
  String time;
  String media;

  Story(this.storyID, this.ownerID, this.ownerusername, this.owneravatar,
      this.time, this.media);

  // JSON'dan Story nesnesi oluşturmak için yardımcı bir metot
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      json['storyId'] as int,
      json['ownerID'] as int,
      json['ownerusername'] as String,
      json['owneravatar'] as String,
      json['time'] as String,
      json['media'] as String,
    );
  }

  // Story sınıfını bir JSON nesnesine dönüştürmek için yardımcı bir metot
  Map<String, dynamic> toJson() => {
        'storyId': storyID,
        'ownerID': ownerID,
        'ownerusername': ownerusername,
        'owneravatar': owneravatar,
        'time': time,
        'media': media,
      };
}
