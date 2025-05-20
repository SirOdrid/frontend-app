import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/UserType.dart';
import 'package:frontend_app/data/repositories/assistant/UserTypeRepository.dart';


class UserTypeProvider with ChangeNotifier {
  final UserTypeRepository _UserType = UserTypeRepository();

  List<UserType> _userTypes = [];
  
  //Public data access
  List<UserType> get userTypes => _userTypes;


// PRE-CACHING
  Future<void> init() async {
    // init charge of data
    _userTypes = await _UserType.getAllUserTypes();
    notifyListeners();
  }

// LAZY LOADING
  Future<List<UserType>> fetchCountries() async {
     _userTypes = await _UserType.getAllUserTypes();
    notifyListeners();
    return _userTypes;   
  }
}
