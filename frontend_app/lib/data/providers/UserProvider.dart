import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/User.dart';
import 'package:frontend_app/data/models/UserLogin.dart';
import 'package:frontend_app/data/models/country.dart';
import 'package:frontend_app/data/repositories/UserRepository.dart';
import 'package:frontend_app/data/repositories/assistant/CountryRepository.dart';


class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final CountryRepository _countryRepository = CountryRepository();

  List<Country> _countries = [];
  List<User> _users = []; 
  User? _user;
  
  //Public data access
  List<Country> get countries => _countries;
  List<User> get users => _users; 
  User? get user => _user;

// PRE-CACHING
  Future<void> init() async {
    // init charge of data
    _countries = await _countryRepository.getAllCountries();
    notifyListeners();
  }

// LAZY LOADING
  Future<void> fetchUsers() async {
    _users = await _userRepository.getUserList();
    notifyListeners();
  }


  Future<void> registryUser(User user) async {
    await _userRepository.registryUser(user);
    _user = user;
    notifyListeners();
  }

  Future<void> loginUser(UserLogin user) async {
    _user = await _userRepository.loginUser(user);
    notifyListeners();
  }

  Future<void> accountEdit(String id, User user) async {
    await _userRepository.accountEdit(id, user);
    _user = user;
    notifyListeners();
  }

  Future<void> accountDelete(int id) async {
    await _userRepository.accountDelete(id);
    notifyListeners();
  }
  
}
