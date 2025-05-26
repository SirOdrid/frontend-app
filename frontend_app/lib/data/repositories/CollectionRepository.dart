import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Boardgame.dart';
import '../services/ApiService.dart';

class CollectionRepository {
  final ApiService _apiService = ApiService();

  Future<List<Boardgame>> getCollectionByUser(int idUser) async {
    try {
      final response = await _apiService.dio.get('${EndpointsApi.endpointGetCollectionByUser}/$idUser');
      return (response.data as List)
          .map((json) => Boardgame.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener la colección");
    }
  }
  
  Future<void> addBoardgameToCollection(int idUser, int idBoardgame) async {
    await _apiService.dio.post('${EndpointsApi.endpointAddCollection}/$idUser/${EndpointsApi.endpointBaseBoardgame}/$idBoardgame');
  }

  Future<void> deleteBoardgameToCollection(int idUser, int idBoardgame) async {
    await _apiService.dio.delete("${EndpointsApi.endpointDeleteCollection}/$idUser/${EndpointsApi.endpointBaseBoardgame}/$idBoardgame");
  }
}