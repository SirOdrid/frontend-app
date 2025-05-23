class BoardgameType {
  final int boardgameTypeId;
  final String boardgameTypeName;

  BoardgameType({
    required this.boardgameTypeId,
    required this.boardgameTypeName,
  });

  int getBoardgameTypeId() => boardgameTypeId;
  String getBoardgameTypeName() => boardgameTypeName;

  factory BoardgameType.fromJson(Map<String, dynamic> json) {
    return BoardgameType(
      boardgameTypeId: json['boardgameTypeId'] ?? 0,
      boardgameTypeName: json['boardgameTypeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boardgameTypeId': boardgameTypeId,
      'boardgameTypeName': boardgameTypeName,
    };
  }
}