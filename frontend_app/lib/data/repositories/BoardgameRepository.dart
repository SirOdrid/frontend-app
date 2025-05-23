import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import 'package:frontend_app/data/services/ApiService.dart';
import 'package:frontend_app/text_content/ErrorMessage.dart';

class BoardgameRepository {
  final ApiService _apiService = ApiService();

  Future<List<Boardgame>> fetchBoardgamesLocal(String nameSearch) async {
    try {
      final response = await _apiService.dio.get('${EndpointsApi.endpointSearchBoardgameLocal}/$nameSearch'); // FALTA CAMBIAR
      return (response.data as List)
          .map((json) => Boardgame.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ErrorMessage.unexpectedError);
    }
  }

  Future<List<Boardgame>> fetchBoardgamesBGG(String nameSearch) async {
    try {
      final response = await _apiService.dio.get('${EndpointsApi.endpointSearchBoardgameInBgg}/$nameSearch');
      return (response.data as List)
          .map((json) => Boardgame.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ErrorMessage.unexpectedError);
    }
  }

}