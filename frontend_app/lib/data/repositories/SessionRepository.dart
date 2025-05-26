import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Session.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class SessionRepository {
  final ApiService _apiService = ApiService();

  Future<List<Session>> getSessionsByUser(int idUser) async {
    try {
      final response = await _apiService.dio
          .get('${EndpointsApi.endpointGetSessionsByUser}/$idUser');
      return (response.data as List)
          .map((json) => Session.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
          print('Error real al obtener las sesiones: $e');
    print('Stacktrace: $stackTrace');
    
    // Opcional: puedes lanzar una excepción más informativa
    throw Exception('Error al obtener las sesiones: $e');
    }
  }

  Future<void> createSession(Session session) async {
    await _apiService.dio
        .post(EndpointsApi.endpointAddSession, data: session.toJson());
  }

  Future<void> updateSession(Session session) async {
    await _apiService.dio.put(
        '${EndpointsApi.endpointEditSession}/${session.sessionId}',
        data: session.toJson());
  }

  Future<void> deleteSession(int idSession) async {
    await _apiService.dio
        .delete('${EndpointsApi.endpointDeleteSession}/$idSession');
  }
}
