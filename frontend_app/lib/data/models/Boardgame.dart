import 'package:frontend_app/data/models/BoardgameGender.dart';
import 'package:frontend_app/data/models/BoardgameType.dart';

class Boardgame {
  final int boardgameId;
  final String boardgameName;
  final int minPlayers;
  final int maxPlayers;
  final int releaseYear;
  final String boardgameDescription;
  final String boardgameImageUrl;
  final String apiBggRef;
  final BoardgameGender fkBoardgameGender;
  final BoardgameType fkBoardgameType;
  final Boardgame? fkBoardgameBase;

  Boardgame({
    required this.boardgameId,
    required this.boardgameName,
    required this.minPlayers,
    required this.maxPlayers,
    required this.releaseYear,
    required this.boardgameDescription,
    required this.boardgameImageUrl,
    required this.apiBggRef,
    required this.fkBoardgameGender,
    required this.fkBoardgameType,
    this.fkBoardgameBase,
  });

  int getBoardgameId() => boardgameId;
  String getBoardgameName() => boardgameName;
  int getMinPlayers() => minPlayers;
  int getMaxPlayers() => maxPlayers;
  int getReleaseYear() => releaseYear;
  String getBoardgameDescription() => boardgameDescription;
  String getBoardgameImageUrl() => boardgameImageUrl;
  String getApiBggRef() => apiBggRef;
  BoardgameGender getFkBoardgameGender() => fkBoardgameGender;
  BoardgameType getFkBoardgameType() => fkBoardgameType;
  Boardgame? getFkBoardgameBase() => fkBoardgameBase;

  factory Boardgame.fromJson(Map<String, dynamic> json) {
    return Boardgame(
      boardgameId: json['boardgameId'] ?? 0,
      boardgameName: json['boardgameName'] ?? '',
      minPlayers: json['minPlayers'] ?? 0,
      maxPlayers: json['maxPlayers'] ?? 0,
      releaseYear: json['releaseYear'] ?? 0,
      boardgameDescription: json['boardgameDescription'] ?? '',
      boardgameImageUrl: json['boardgameImageUrl'] ?? '',
      apiBggRef: json['apiBggRef'] ?? '',
      fkBoardgameGender: BoardgameGender.fromJson(json['fkBoardgameGender'] ?? {}),
      fkBoardgameType: BoardgameType.fromJson(json['fkBoardgameType'] ?? {}),
      fkBoardgameBase: json['fkBoardgameBase'] != null 
          ? Boardgame.fromJson(json['fkBoardgameBase']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boardgameId': boardgameId,
      'boardgameNameRq': boardgameName,
      'minPlayersRq': minPlayers,
      'maxPlayersRq': maxPlayers,
      'releaseYearRq': releaseYear,
      'boardgameDescriptionRq': boardgameDescription,
      'boardgameImageUrlRq': boardgameImageUrl,
      'refApiBggRq': apiBggRef,
      'fkBoardgameGenderRq': fkBoardgameGender.toJson(),
      'fkBoardgameTypeRq': fkBoardgameType.toJson(),
      'fkBoardgameBaseRq': fkBoardgameBase?.toJson(),
    };
  }
}