import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/LoanState.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class LoanStateRepository {
  final ApiService _apiService = ApiService();

  Future<List<LoanState>> getAllLoanStates() async {
    try {
      final response = await _apiService.dio.get(EndpointsApi.endpointAllLoanStates);
      return (response.data as List)
          .map((json) => LoanState.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener estados de prestamos");
    }
  }
}