import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/text_content/ErrorMessage.dart';
import 'package:frontend_app/data/models/country.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class CountryRepository {
  final ApiService _apiService = ApiService();


  Future<List<Country>> getAllCountries() async {
    try {
      final response = await _apiService.dio.get(EndpointsApi.endpointAllCountries);
      return (response.data as List)
          .map((json) => Country.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(ErrorMessage.unexpectedError);
    }
  }
}