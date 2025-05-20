import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/UserType.dart';
import 'package:frontend_app/text_content/ErrorMessage.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class UserTypeRepository {
  final ApiService _apiService = ApiService();


  Future<List<UserType>> getAllUserTypes() async {
    try {
      final response = await _apiService.dio.get(EndpointsApi.endpointAllUserTypes);
      return (response.data as List)
          .map((json) => UserType.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ErrorMessage.unexpectedError);
    }
  }
}