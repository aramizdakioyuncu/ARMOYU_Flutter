class News {
  int newsId;
  String newsTitle;
  String newsContent;
  String author;

  News(this.newsId, this.newsTitle, this.newsContent, this.author);

  // JSON'dan News nesnesi oluşturmak için yardımcı bir metot
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      json['newsId'] as int,
      json['newsTitle'] as String,
      json['newsContent'] as String,
      json['author'] as String,
    );
  }

  // News sınıfını bir JSON nesnesine dönüştürmek için yardımcı bir metot
  Map<String, dynamic> toJson() => {
        'newsId': newsId,
        'newsTitle': newsTitle,
        'newsContent': newsContent,
        'author': author,
      };
}
