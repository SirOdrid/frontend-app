class BoardgameStats {
  final int boardgameId;
  final String boardgameName;
  final int totalGames;
  final Duration averageDuration;
  final bool inCollection;

  BoardgameStats({
    required this.boardgameId,
    required this.boardgameName,
    required this.totalGames,
    required this.averageDuration,
    required this.inCollection,
  });

  int getBoardgameId() => boardgameId;
  String getBoardgameName() => boardgameName;
  int getTotalGames() => totalGames;
  Duration getAverageDuration() => averageDuration;
  bool isInCollection() => inCollection;

  factory BoardgameStats.fromJson(Map<String, dynamic> json) {
    final durationParts = (json['averageDuration'] ?? '00:00:00').split(':');
    final duration = Duration(
      hours: int.parse(durationParts[0]),
      minutes: int.parse(durationParts[1]),
      seconds: int.parse(durationParts[2]),
    );

    return BoardgameStats(
      boardgameId: json['id'] ?? 0,
      boardgameName: json['boardgameName'] ?? '',
      totalGames: json['totalGames'] ?? 0,
      averageDuration: duration,
      inCollection: json['inCollection'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': boardgameId,
      'boardgameName': boardgameName,
      'totalGames': totalGames,
      'averageDuration': formatDuration(averageDuration),
      'inCollection': inCollection,
    };
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
