class BoardgamePlayStats {
  final int id;
  final String boardgameName;
  final String boardgameGenderName;
  final int playCount;

  BoardgamePlayStats({
    required this.id,
    required this.boardgameName,
    required this.boardgameGenderName,
    required this.playCount,
  });

  int getId() => id;
  String getBoardgameName() => boardgameName;
  String getBoardgameGenderName() => boardgameGenderName;
  int getPlayCount() => playCount;

  factory BoardgamePlayStats.fromJson(Map<String, dynamic> json) {
    return BoardgamePlayStats(
      id: json['id'] ?? 0,
      boardgameName: json['boardgameName'] ?? '',
      boardgameGenderName: json['boardgameGenderName'] ?? '',
      playCount: json['playCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'boardgameName': boardgameName,
      'boardgameGenderName': boardgameGenderName,
      'playCount': playCount,
    };
  }
}
