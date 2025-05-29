import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Loan.dart';
import 'package:frontend_app/data/repositories/LoanRepository.dart';

class LoanProvider with ChangeNotifier {
  final LoanRepository _loanRepository = LoanRepository();

  List<Loan> _loans = [];

  List<Loan> get loans => _loans;

  Future<List<Loan>> getLoansByUser(int idUser) async {
    _loans = await _loanRepository.getLoansByUser(idUser);
    notifyListeners();
    return _loans;
  }

  // Future<List<Loan>> getLoansByStock(int idStock) async {
  //   _loans = await _loanRepository.getLoansByStock(idStock);
  //   notifyListeners();
  //   return _loans;
  // }

  Future<void> addLoan(int idUser, Loan loan) async {
    await _loanRepository.addLoan(loan);
    getLoansByUser(idUser);
  }

  Future<void> updateLoan(int idUser, Loan loan) async {
    await _loanRepository.updateLoan(loan);
    getLoansByUser(idUser);
  }

  Future<void> deleteLoan(int idUser, int loanId) async {
    await _loanRepository.deleteLoan(loanId);
    getLoansByUser(idUser);
  }

  int countLoansByStockId(int stockId) {
    return _loans.where((loan) => loan.fkStock.stockId == stockId).length;
  }

}