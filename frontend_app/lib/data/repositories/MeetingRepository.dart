import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Meeting.dart';
import '../services/ApiService.dart';

class MeetingRepository {
  final ApiService _apiService = ApiService();


  Future<List<Meeting>> getMeetingsByUser(int idHostUser) async {
    try {
      final response = await _apiService.dio
          .get('${EndpointsApi.endpointGetMeetingsByUser}/$idHostUser');
      return (response.data as List)
          .map((json) => Meeting.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      print('Error al obtener las partidas: $e');
      print('Stacktrace: $stackTrace');
      throw Exception("Error al obtener las partidas");
    }
  }

  Future<void> createMeeting(Meeting meeting) async {
    await _apiService.dio
        .post(EndpointsApi.endpointAddMeeting, data: meeting.toJson());
  }

  Future<void> deleteMeeting(int idHostUser) async {
    await _apiService.dio
        .delete('${EndpointsApi.endpointDeleteMeeting}/$idHostUser');
  }
}