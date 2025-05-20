
import 'package:dio/dio.dart';
import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/text_content/ErrorMessage.dart';
import 'package:frontend_app/data/models/UserLogin.dart';

import '../models/User.dart';
import '../services/ApiService.dart';

class UserRepository {
  final ApiService _apiService = ApiService();

  Future<List<User>> getUserList() async {
    try {
      final response = await _apiService.dio.get("/users/getall");
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener usuarios");
    }
  }

  Future<void> registryUser(User user) async {
    await _apiService.dio.post(EndpointsApi.endpointRegistry, data: user.toJson());
  }

  Future<User> loginUser(UserLogin userLogin) async {
    try {
      final response = await _apiService.dio.get(EndpointsApi.endpointLogin, data: userLogin.toJson(),
        options: Options(
          responseType: ResponseType.plain
        ),
      );
      if (response.data is String) {
        throw Exception(response.data);
      }else{
        return (response.data).map((json) => User.fromJson(json));
      }        
    } catch (e) {
      throw Exception(ErrorMessage.unexpectedError);
    }
  }

  Future<void> accountEdit(String id, User user) async {
    await _apiService.dio.put("${EndpointsApi.endpointBaseUser}/$id", data: user.toJson());
  }

  Future<void> accountDelete(int id) async {
    await _apiService.dio.delete("${EndpointsApi.endpointBaseUser}/$id");
  }
}
