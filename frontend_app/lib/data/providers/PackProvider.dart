import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Pack.dart';
import 'package:frontend_app/data/repositories/PackRepository.dart';

class PackProvider with ChangeNotifier{
  final PackRepository _packRepository = PackRepository();
  
  List<Pack> _packs = [];

  List<Pack> get packs => _packs;

  Future<List<Pack>> getPacksByUser(int idUser) async {
    _packs = await _packRepository.getPacksByUser(idUser);
    notifyListeners();
    return _packs;
  }

  Future<Pack> createPack(int idUser, Pack pack) async {
    Pack newPack = await _packRepository.createPack(pack);
    getPacksByUser(idUser);
    return newPack;
  }

  Future<void> deletePack(int idUser, int idPack) async {
    await _packRepository.deletePack(idPack);
    getPacksByUser(idUser);
  }

  Future<void> addBoardgameToPack (int idPack, idBoardgame, int idUser) async {
    await _packRepository.addBoardgameToPack(idPack, idBoardgame);
    getPacksByUser(idUser);
  }

  Future<void> deleteBoardgameToPack (int idPack, idBoardgame, int idUser) async {
    await _packRepository.deleteBoardgameToPack(idPack, idBoardgame);
    getPacksByUser(idUser);
  }
}