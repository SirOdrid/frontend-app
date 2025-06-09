class UnplayedPopularBoardgame {
  final int id;
  final String boardgameName;
  final String boardgameDescription;
  final int globalPlayCount;

  UnplayedPopularBoardgame({
    required this.id,
    required this.boardgameName,
    required this.boardgameDescription,
    required this.globalPlayCount,
  });

  factory UnplayedPopularBoardgame.fromJson(Map<String, dynamic> json) {
    return UnplayedPopularBoardgame(
      id: json['id'],
      boardgameName: json['boardgameName'],
      boardgameDescription: json['boardgameDescription'],
      globalPlayCount: json['globalPlayCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'boardgameName': boardgameName,
      'boardgameDescription': boardgameDescription,
      'globalPlayCount': globalPlayCount,
    };
  }
}
