import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/UserAssociate.dart';
import '../models/User.dart';
import '../services/ApiService.dart';

class UserAssociateRepository {
  final ApiService _apiService = ApiService();

  Future<List<UserAssociate>> getAssociations(int id) async {
    try {
      final response = await _apiService.dio.get('${EndpointsApi.endpointAllAssociations}/$id');
      return (response.data as List)
          .map((json) => UserAssociate.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener asociaciones");
    }
  }
  
  Future<List<UserAssociate>> getAssociates(int id) async {
    try {
      final response = await _apiService.dio.get('${EndpointsApi.endpointAllAssociates}/$id');
      return (response.data as List)
          .map((json) => UserAssociate.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener asociaciados");
    }
  }

  Future<void> addAssociation(User userHost, User activeUser) async {
    await _apiService.dio.post(EndpointsApi.endpointAddAssociation, data: UserAssociate(
      userAssociateId: activeUser.userId, 
      fkHostUser: userHost, 
      fkAssociatedUser: activeUser, 
      associationDate: DateTime.now()
    ).toJson());
  }

  Future<void> deleteAssociation(String id) async {
    await _apiService.dio.delete("${EndpointsApi.endpointDeleteAssociation}/$id");
  }

}