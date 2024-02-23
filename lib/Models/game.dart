class Game {
  int gameId;
  String gameName;
  String gameType;

  Game(this.gameId, this.gameName, this.gameType);

  // Game sınıfından nesne oluşturmak için yardımcı bir metot
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      json['gameId'] as int,
      json['gameName'] as String,
      json['gameType'] as String,
    );
  }

  // Game sınıfını bir JSON nesnesine dönüştürmek için yardımcı bir metot
  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'gameName': gameName,
        'gameType': gameType,
      };
}
