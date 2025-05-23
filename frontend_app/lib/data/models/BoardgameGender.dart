class BoardgameGender {
  final int boardgameGenderId;
  final String boardgameGenderName;

  BoardgameGender({
    required this.boardgameGenderId,
    required this.boardgameGenderName,
  });

  int getBoardgameGenderId() => boardgameGenderId;
  String getBoardgameGenderName() => boardgameGenderName;

  factory BoardgameGender.fromJson(Map<String, dynamic> json) {
    return BoardgameGender(
      boardgameGenderId: json['boardgameGenderId'] ?? 0,
      boardgameGenderName: json['boardgameGenderName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boardgameGenderId': boardgameGenderId,
      'boardgameGenderName': boardgameGenderName,
    };
  }
}