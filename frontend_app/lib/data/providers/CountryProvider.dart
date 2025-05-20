import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/country.dart';
import 'package:frontend_app/data/repositories/assistant/CountryRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;


class CountryProvider with ChangeNotifier {
  final CountryRepository _countryRepository = CountryRepository();

  List<Country> _countries = [];
  
  //Public data access
  List<Country> get countries => _countries;
  


// PRE-CACHING
  Future<void> init() async {
    // init charge of data
    _countries = await _countryRepository.getAllCountries();
    notifyListeners();
  }

// LAZY LOADING
final allCountries = FutureProvider<List<Country>>((ref) async {
  final response = await http.get(Uri.parse("${EndpointsApi.baseUrl}${EndpointsApi.endpointAllCountries}"));
  if (response.statusCode == 200) {
    return List<Country>.from(
      json.decode(response.body).map((x) => Country.fromJson(x)),
    );
  } else {
    throw Exception('Error al cargar países');
  }
});
  
}
