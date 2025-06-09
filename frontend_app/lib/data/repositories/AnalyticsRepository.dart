import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Analytics/BoardgameLoanStats.dart';
import 'package:frontend_app/data/models/Analytics/BoardgameOwnershipStats.dart';
import 'package:frontend_app/data/models/Analytics/BoardgamePlayStats.dart';
import 'package:frontend_app/data/models/Analytics/BoardgameStats.dart';
import 'package:frontend_app/data/models/Analytics/TopGenreByUser.dart';
import 'package:frontend_app/data/models/Analytics/UnplayedPoupularBoardgame.dart';
import 'package:frontend_app/data/models/Analytics/UsageBoardgame.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class AnalyticsRepository {
  final ApiService _apiService = ApiService();

  Future<List<BoardgameStats>> getBoardgameStatsByUser(int userId) async {
    try {
      final response = await _apiService.dio
          .get('${EndpointsApi.endpointBoardgamesStats}/$userId');
      return (response.data as List)
          .map((json) => BoardgameStats.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener estadísticas: $e");
    }
  }

  Future<List<TopGenreByUser>> getTopGenresByUser(int userId) async {
    try {
      final response = await _apiService.dio
          .get('${EndpointsApi.endpointTopGenresByUser}/$userId');
      return (response.data as List)
          .map((json) => TopGenreByUser.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener los géneros de la colección: $e");
    }
  }

  Future<List<UsageBoardgame>> getLowUsageBoardgames(int userId) async {
    try {
      final response = await _apiService.dio.get('/analytics/usage/user/$userId');

      final data = response.data as List<dynamic>;
      return data.map((item) => UsageBoardgame.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error al obtener juegos con bajo uso: $e');
    }
  }

  Future<List<UnplayedPopularBoardgame>> getUnplayedPopularBoardgames(int userId) async {
    try {
      final response = await _apiService.dio.get('/analytics/recommended/user/$userId');
      final data = response.data as List<dynamic>;
      return data.map((item) => UnplayedPopularBoardgame.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error al obtener juegos recomendados: $e');
    }
  }

  Future<List<BoardgamePlayStats>> getBoardgamePlayStatsByUser(int userId) async {
     try {
      final response = await _apiService.dio
          .get('/analytics/associate_boardgames/user/$userId');
      return (response.data as List)
          .map((json) => BoardgamePlayStats.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener la actividad de los asociados: $e");
    }
  }

  Future<List<BoardgameOwnershipStats>> getBoardgameOwnershipStatsByUser(int userId) async {
    try {
      final response = await _apiService.dio
          .get('/analytics/associate_compose/user/$userId');
      return (response.data as List)
          .map((json) => BoardgameOwnershipStats.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener la composicion de las colecciones de los asociados: $e");
    }
  }

  Future<List<BoardgameLoanStats>> getBoardgameLoanStatsByUser(int userId) async {
    try {
      final response = await _apiService.dio
          .get('/analytics/loan_activity/user/$userId');
      return (response.data as List)
          .map((json) => BoardgameLoanStats.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener las estadisticas de prestamos: $e");
    }
  }
}
