import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/User.dart';

class Stock {
  final int stockId;
  final int units;
  final User fkUser;
  final Boardgame fkBoardgame;

  Stock({
    required this.stockId, 
    required this.units, 
    required this.fkUser, 
    required this.fkBoardgame
  });

  int getStockId() => stockId;
  int getUnits() => units;
  User getFkUser() => fkUser;
  Boardgame getFkBoardgame() => fkBoardgame;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    stockId: json['stockId'], 
    units: json['units'], 
    fkUser: User.fromJson(json['fkUser']), 
    fkBoardgame: Boardgame.fromJson(json['fkBoardgame'])
  );

  Map<String, dynamic> toJson() => {
    'stockIdRq': stockId, 
    'unitsRq': units, 
    'FkUserRq': fkUser.userId, 
    'FkBoardgameRq': fkBoardgame.boardgameId
  };
}