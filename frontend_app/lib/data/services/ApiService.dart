import 'package:dio/dio.dart';
import 'package:frontend_app/data/EndpointsApi.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: EndpointsApi.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        //options.headers["Authorization"] = "Bearer TOKEN"; // Autenticación si es necesario
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print("Error en la API: ${e.response?.statusCode} ${_dio.options.baseUrl} ${e.response?.data}");
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
