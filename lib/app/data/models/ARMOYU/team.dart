class Team {
  int teamID;
  String name;
  String logo;

  Team({
    required this.teamID,
    required this.name,
    required this.logo,
  });

  // Convert Team instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'teamID': teamID,
      'name': name,
      'logo': logo,
    };
  }

  // Convert JSON to Team instance
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamID: json['teamID'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}
