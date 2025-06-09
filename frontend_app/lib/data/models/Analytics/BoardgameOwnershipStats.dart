class BoardgameOwnershipStats {
  final int id;
  final String boardgameName;
  final int totalAssociatesWithGame;
  final double ownershipPercentage;
  final bool inUserCollection;

  BoardgameOwnershipStats({
    required this.id,
    required this.boardgameName,
    required this.totalAssociatesWithGame,
    required this.ownershipPercentage,
    required this.inUserCollection,
  });

  int getId() => id;
  String getBoardgameName() => boardgameName;
  int getTotalAssociatesWithGame() => totalAssociatesWithGame;
  double getOwnershipPercentage() => ownershipPercentage;
  bool isInUserCollection() => inUserCollection;

  factory BoardgameOwnershipStats.fromJson(Map<String, dynamic> json) {
    return BoardgameOwnershipStats(
      id: json['id'] ?? 0,
      boardgameName: json['boardgameName'] ?? '',
      totalAssociatesWithGame: json['totalAssociatesWithGame'] ?? 0,
      ownershipPercentage:
          (json['ownershipPercentage'] is int) ? (json['ownershipPercentage'] as int).toDouble() : (json['ownershipPercentage'] ?? 0.0),
      inUserCollection: json['inUserCollection'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'boardgameName': boardgameName,
      'totalAssociatesWithGame': totalAssociatesWithGame,
      'ownershipPercentage': ownershipPercentage,
      'inUserCollection': inUserCollection,
    };
  }
}
