class BoardgameLoanStats {
  final String boardgameName;
  final int totalLoans;
  final int totalStock;
  final double averageDurationDays;
  final double averageLoansPerMonth;

  BoardgameLoanStats({
    required this.boardgameName,
    required this.totalLoans,
    required this.totalStock,
    required this.averageDurationDays,
    required this.averageLoansPerMonth,
  });

  String getBoardgameName() => boardgameName;
  int getTotalLoans() => totalLoans;
  int getTotalStock() => totalStock;
  double getAverageDurationDays() => averageDurationDays;
  double getAverageLoansPerMonth() => averageLoansPerMonth;

  factory BoardgameLoanStats.fromJson(Map<String, dynamic> json) {
    return BoardgameLoanStats(
      boardgameName: json['boardgameName'] ?? '',
      totalLoans: json['totalLoans'] ?? 0,
      totalStock: json['totalStock'] ?? 0,
      averageDurationDays:
          (json['averageDurationDays'] is int) ? (json['averageDurationDays'] as int).toDouble() : (json['averageDurationDays'] ?? 0.0),
      averageLoansPerMonth:
          (json['averageLoansPerMonth'] is int) ? (json['averageLoansPerMonth'] as int).toDouble() : (json['averageLoansPerMonth'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boardgameName': boardgameName,
      'totalLoans': totalLoans,
      'totalStock': totalStock,
      'averageDurationDays': averageDurationDays,
      'averageLoansPerMonth': averageLoansPerMonth,
    };
  }
}
