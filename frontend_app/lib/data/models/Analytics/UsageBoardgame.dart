class UsageBoardgame {
  final int id;
  final String boardgameName;
  final int totalPlayed;
  final DateTime registryDate;
  final double usageRate;

  UsageBoardgame({
    required this.id,
    required this.boardgameName,
    required this.totalPlayed,
    required this.registryDate,
    required this.usageRate,
  });

  factory UsageBoardgame.fromJson(Map<String, dynamic> json) {
    return UsageBoardgame(
      id: json['id'],
      boardgameName: json['boardgameName'],
      totalPlayed: json['totalPlayed'],
      registryDate: DateTime.parse(json['registryDate']),
      usageRate: (json['usageRate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'boardgameName': boardgameName,
      'totalPlayed': totalPlayed,
      'registryDate': registryDate.toIso8601String(),
      'usageRate': usageRate,
    };
  }
}
