import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/models/Stock.dart';
import 'package:frontend_app/data/repositories/CollectionRepository.dart';

class CollectionProvider with ChangeNotifier {
  final CollectionRepository _collectionRepository = CollectionRepository();

  List<Boardgame> _collection = [];

  List<Boardgame> get collections => _collection;

  Future<List<Boardgame>> fetchCollectionByUser(int idActiveUser) async {
    _collection = await _collectionRepository.getCollectionByUser(idActiveUser);
    notifyListeners();
    return _collection;
  }

  Future<void> addBoardgameToCollection(int idUser, int idBoardgame) async {
    await _collectionRepository.addBoardgameToCollection(idUser, idBoardgame);
    fetchCollectionByUser(idUser);
  }

  Future<void> deleteBoardgameToCollection(int idUser, int idBoardgame) async {
    await _collectionRepository.deleteBoardgameToCollection(
        idUser, idBoardgame);
    fetchCollectionByUser(idUser);
  }

  bool isInCollection(int boardgameId) {
    return _collection.any((boardgame) => boardgame.boardgameId == boardgameId);
  }

  List<Boardgame> getBoardgamesInStock(List<Stock> stockList, bool isInStock) {
  final stockBoardgameIds = stockList.map((stock) => stock.fkBoardgame.boardgameId).toSet();
  if (isInStock) {
    return _collection
        .where((boardgame) => stockBoardgameIds.contains(boardgame.boardgameId))
        .toList();
  }
  return _collection
      .where((boardgame) => !stockBoardgameIds.contains(boardgame.boardgameId))
      .toList();
  }
}
