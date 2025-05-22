
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/UserRecovery.dart';
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
    final response = await _apiService.dio.post(
      EndpointsApi.endpointLogin,
      data: userLogin.toJson(),
      options: Options(responseType: ResponseType.plain),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data); 
    }

    return User.fromJson(jsonDecode(response.data)); 
  } on DioException catch (e) {
    if (e.response != null) {
      throw Exception(e.response?.data ?? "Error desconocido del servidor");
    } else {
      throw Exception("Error de red: ${e.message}");
    }
  } catch (e) {
    throw Exception("Error inesperado: $e");
  }
}

  Future<void> accountEdit(String id, User user) async {
    await _apiService.dio.put("${EndpointsApi.endpointBaseUser}/$id", data: user.toJson());
  }

  Future<void> accountDelete(int id) async {
    await _apiService.dio.delete("${EndpointsApi.endpointBaseUser}/$id");
  }

  Future<void> passwordRecovery(UserRecovery userRecovery) async {
  try {
    final response = await _apiService.dio.put(
      EndpointsApi.endpointPasswordRecovery,
      data: userRecovery.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.data.toString()));
    }
  } on DioException catch (dioError) {
    if (dioError.response != null && dioError.response!.data != null) {
      throw Exception(dioError.response!.data.toString());
    } else {
      throw Exception("Error de red: ${dioError.message}");
    }
  } catch (e) {
    throw Exception("Error inesperado: $e");
  }
}

}
