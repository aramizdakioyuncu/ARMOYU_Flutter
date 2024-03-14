class Media {
  int? mediaID;
  int? ownerID;
  String? ownerusername;
  String? owneravatar;
  String? mediaTime;
  String? mediaType;
  MediaURL mediaURL;
  String? mediaDirection;

  Media({
    this.mediaID,
    this.ownerID,
    this.ownerusername,
    this.owneravatar,
    this.mediaTime,
    this.mediaType,
    required this.mediaURL,
    this.mediaDirection,
  });
}

class MediaURL {
  String bigURL;
  String normalURL;
  String minURL;

  MediaURL({
    required this.bigURL,
    required this.normalURL,
    required this.minURL,
  });
}
