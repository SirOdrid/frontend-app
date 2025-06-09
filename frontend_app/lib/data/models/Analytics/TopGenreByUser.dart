class TopGenreByUser {
  final int id;
  final String genreName;
  final int totalGames;

  TopGenreByUser({
    required this.id,
    required this.genreName,
    required this.totalGames,
  });

  factory TopGenreByUser.fromJson(Map<String, dynamic> json) {
    return TopGenreByUser(
      id: json['id'] ?? 0,
      genreName: json['genreName'] ?? '',
      totalGames: json['totalGames'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'genreName': genreName,
      'totalGames': totalGames,
    };
  }
}
