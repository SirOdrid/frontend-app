import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/repositories/BoardgameRepository.dart';

class BoardgameProvider with ChangeNotifier{
  final BoardgameRepository _boardgameRepository = BoardgameRepository();

  List<Boardgame> boardgames = [];

  Future<List<Boardgame>> fetchBoardgamesLocal(String nameSearch) async {
    boardgames = await _boardgameRepository.fetchBoardgamesLocal(nameSearch);
    notifyListeners();
    return boardgames;
  }

  Future<List<Boardgame>> fetchBoardgamesBGG(String nameSearch) async {
    boardgames = await _boardgameRepository.fetchBoardgamesBGG(nameSearch);
    notifyListeners();
    return boardgames;
  }

}