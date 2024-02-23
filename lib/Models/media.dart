class Media {
  int mediaID;
  int ownerID;
  String ownerusername;
  String owneravatar;
  String mediaTime;
  String mediaType;
  String mediaURL;

  Media(this.mediaID, this.ownerID, this.ownerusername, this.owneravatar,
      this.mediaTime, this.mediaType, this.mediaURL);

  // JSON'dan Story nesnesi oluşturmak için yardımcı bir metot
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      json['mediaID'] as int,
      json['ownerID'] as int,
      json['ownerusername'] as String,
      json['owneravatar'] as String,
      json['mediaTime'] as String,
      json['mediaType'] as String,
      json['mediaURL'] as String,
    );
  }

  // Story sınıfını bir JSON nesnesine dönüştürmek için yardımcı bir metot
  Map<String, dynamic> toJson() => {
        'mediaID': mediaID,
        'ownerID': ownerID,
        'ownerusername': ownerusername,
        'owneravatar': owneravatar,
        'mediaTime': mediaTime,
        'mediaType': mediaType,
        'mediaURL': mediaURL,
      };
}
