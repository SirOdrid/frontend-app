import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Pack.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class PackRepository {
  final ApiService _apiService = ApiService();


  Future<List<Pack>> getPacksByUser(int idHostUser) async {
    try {
      final response = await _apiService.dio
          .get('${EndpointsApi.endpointGetPacksByUser}/$idHostUser');
      return (response.data as List)
          .map((json) => Pack.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      print('Error al obtener los packs: $e');
      print('Stacktrace: $stackTrace');
      throw Exception("Error al obtener los packs");
    }
  }

  Future<Pack> createPack(Pack pack) async {
  final response = await _apiService.dio.post(
    EndpointsApi.endpointAddPack,
    data: pack.toJson(),
  );
  return Pack.fromJson(response.data);
}


  Future<void> deletePack(int idHostUser) async {
    await _apiService.dio
        .delete('${EndpointsApi.endpointDeletePack}/$idHostUser');
  }

  Future<void> addBoardgameToPack(int idPack, int idBoardgame) async {
    await _apiService.dio.post('${EndpointsApi.endpointBaseBoardgamePack}/$idPack/${EndpointsApi.endpointBaseBoardgame}/$idBoardgame');
  }

  Future<void> deleteBoardgameToPack(int idPack, int idBoardgame) async {
    await _apiService.dio.delete("${EndpointsApi.endpointBaseBoardgamePack}/$idPack/${EndpointsApi.endpointBaseBoardgame}/$idBoardgame");
  }

}