import 'package:frontend_app/data/models/LoanState.dart';
import 'package:frontend_app/data/models/Stock.dart';
import 'package:frontend_app/data/models/User.dart';

class Loan {
  final int loanId;
  final DateTime loanDate;
  final DateTime expirationDate;
  final User fkUser;
  final Stock fkStock;
  final LoanState fkLoanState;

  Loan({
    required this.loanId, 
    required this.loanDate, 
    required this.expirationDate, 
    required this.fkUser, 
    required this.fkStock, 
    required this.fkLoanState
  });

  int getLoanId() => loanId;
  DateTime getLoanDate() => loanDate;
  DateTime getExpirationDate() => expirationDate;
  User getFkUser() => fkUser;
  Stock getFkStock() => fkStock;
  LoanState getFkLoanState() => fkLoanState;

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
    loanId: json['loanId'], 
    loanDate: DateTime.parse(json['loanDate']), 
    expirationDate: DateTime.parse(json['expirationDate']), 
    fkUser: User.fromJson(json['fkUser']), 
    fkStock: Stock.fromJson(json['fkStock']), 
    fkLoanState: LoanState.fromJson(json['fkLoanState'])
  );

  Map<String, dynamic> toJson() => {
    'loanId': loanId, 
    'loanDateRq': loanDate.toIso8601String(), 
    'expirationDateRq': expirationDate.toIso8601String(), 
    'fkUserRq': fkUser.userId, 
    'fkStockRq': fkStock.stockId, 
    'fkLoanStateRq': fkLoanState.loanStateId
  };

}