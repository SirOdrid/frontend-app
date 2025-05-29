import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/LoanState.dart';
import 'package:frontend_app/data/repositories/assistant/LoanStateRepository.dart';

class LoanStateProvider with ChangeNotifier{
  final LoanStateRepository _loanstateRepository = LoanStateRepository();

  List<LoanState> _loanStates = [];

  List<LoanState> get loanStates => _loanStates;

  // PRE-CACHING
  Future<void> init() async {
    _loanStates = await _loanstateRepository.getAllLoanStates();
    notifyListeners();
  }

  Future<List<LoanState>> getAllLoanStates() async {
    _loanStates = await _loanstateRepository.getAllLoanStates();
    notifyListeners();
    return _loanStates;
  }


}