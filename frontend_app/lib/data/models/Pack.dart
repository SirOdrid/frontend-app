import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/User.dart';

class Pack {
  final int packId;
  final String packName;
  final User fkUser;
  final List<Boardgame> boardgames;

  Pack({
    required this.packId,
    required this.packName,
    required this.fkUser,
    required this.boardgames,
  });

  int getPackId() => packId;
  String getPackName() => packName;
  User getFkUser() => fkUser;
  List<Boardgame> getBoardgames() => boardgames;

  factory Pack.fromJson(Map<String, dynamic> json) => Pack(
        packId: json['packId'],
        packName: json['packName'],
        fkUser: User.fromJson(json['fkUser']),
        boardgames: json['boardgamePacks'] != null
            ? List<Boardgame>.from(
                json['boardgamePacks']
                    .map((x) => Boardgame.fromJson(x['fkBoardgame'])))
            : <Boardgame>[],
      );

  Map<String, dynamic> toJson() => {
        'packIdRq': packId,
        'packNameRq': packName,
        'fkUserRq': fkUser.userId,
        'boardgamesRq': boardgames.map((bg) => bg.toJson()).toList(),
      };
}

