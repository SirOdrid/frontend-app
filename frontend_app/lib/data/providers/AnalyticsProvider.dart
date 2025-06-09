import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Analytics/BoardgameLoanStats.dart';
import 'package:frontend_app/data/models/Analytics/BoardgameOwnershipStats.dart';
import 'package:frontend_app/data/models/Analytics/BoardgamePlayStats.dart';
import 'package:frontend_app/data/models/Analytics/BoardgameStats.dart';
import 'package:frontend_app/data/models/Analytics/TopGenreByUser.dart';
import 'package:frontend_app/data/models/Analytics/UnplayedPoupularBoardgame.dart';
import 'package:frontend_app/data/models/Analytics/UsageBoardgame.dart';
import 'package:frontend_app/data/repositories/AnalyticsRepository.dart';

class AnalyticsProvider with ChangeNotifier {
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  List<BoardgameStats> _boardgameStats = [];
  List<TopGenreByUser> _topGenres = [];
  List<UsageBoardgame> _lowUsageBoardgames = [];
  List<UnplayedPopularBoardgame> _unplayedPopularBoardgames = [];
  List<BoardgamePlayStats> _boardgamePlayStats = [];
  List<BoardgameOwnershipStats> _boardgameOwnershipStats = [];
  List<BoardgameLoanStats> _boardgameLoanStats = [];

  List<BoardgameStats> get boardgameStats => _boardgameStats;
  List<TopGenreByUser> get topGenres => _topGenres;
  List<UsageBoardgame> get lowUsageBoardgames => _lowUsageBoardgames;
  List<UnplayedPopularBoardgame> get unplayedPopularBoardgames => _unplayedPopularBoardgames;
  List<BoardgamePlayStats> get boardgamePlayStats => _boardgamePlayStats;
  List<BoardgameOwnershipStats> get boardgameOwnershipStats => _boardgameOwnershipStats;
  List<BoardgameLoanStats> get boardgameLoanStats => _boardgameLoanStats;

  Future<List<BoardgameStats>> getBoardgameStatsByUser(int userId) async {
    _boardgameStats =
        await _analyticsRepository.getBoardgameStatsByUser(userId);
    notifyListeners();
    return _boardgameStats;
  }

  Future<List<TopGenreByUser>> getTopGenresByUser(int userId) async {
    _topGenres = await _analyticsRepository.getTopGenresByUser(userId);
    notifyListeners();
    return _topGenres;
  }

  Future<List<UsageBoardgame>> getLowUsageBoardgames(int userId) async {
    _lowUsageBoardgames = await _analyticsRepository.getLowUsageBoardgames(userId);
    notifyListeners();
    return _lowUsageBoardgames;
  }

  Future<List<UnplayedPopularBoardgame>> getUnplayedPopularBoardgames(int userId) async {
    _unplayedPopularBoardgames = await _analyticsRepository.getUnplayedPopularBoardgames(userId);
    notifyListeners();
    return _unplayedPopularBoardgames;
  }

  Future<List<BoardgamePlayStats>> getBoardgamePlayStatsByUser(int userId) async {
    _boardgamePlayStats = await _analyticsRepository.getBoardgamePlayStatsByUser(userId);
    notifyListeners();
    return _boardgamePlayStats;
  }

  Future<List<BoardgameOwnershipStats>> getBoardgameOwnershipStatsByUser(int userId) async {
    _boardgameOwnershipStats = await _analyticsRepository.getBoardgameOwnershipStatsByUser(userId);
    notifyListeners();
    return _boardgameOwnershipStats;
  }

  Future<List<BoardgameLoanStats>> getBoardgameLoanStatsByUser(int userId) async {
    _boardgameLoanStats = await _analyticsRepository.getBoardgameLoanStatsByUser(userId);
    notifyListeners();
    return _boardgameLoanStats;
  }
}
