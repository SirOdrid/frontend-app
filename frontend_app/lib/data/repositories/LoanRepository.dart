import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Loan.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class LoanRepository { 
  final ApiService _apiService = ApiService();

  Future<List<Loan>> getLoansByUser (int idUser) async {
    try {
      final response = await _apiService.dio
          .get('${EndpointsApi.endpointGetLoansByUser}/$idUser');
      return (response.data as List)
          .map((json) => Loan.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      print('Error al obtener los prestamos: $e');
      print('Stacktrace: $stackTrace');
      throw Exception("Error al obtener los prestamos");
    }
  }

  // Future<List<Loan>> getLoansByStock (int idStock) async {
  //   try {
  //     final response = await _apiService.dio
  //         .get('${EndpointsApi.endpointGetLoansByStock}/$idStock');
  //     return (response.data as List)
  //         .map((json) => Loan.fromJson(json))
  //         .toList();
  //   } catch (e, stackTrace) {
  //     print('Error al obtener los prestamos: $e');
  //     print('Stacktrace: $stackTrace');
  //     throw Exception("Error al obtener los prestamos");
  //   }
  // }

  Future<void> addLoan(Loan loan) async {
    await _apiService.dio.post(EndpointsApi.endpointAddLoan, data: loan.toJson());
  }


  Future<void> updateLoan(Loan loan) async {
    await _apiService.dio.put('${EndpointsApi.endpointEditLoan}/${loan.loanId}', data: loan.toJson());
  }

  Future<void> deleteLoan(int loanId) async {
    await _apiService.dio.delete('${EndpointsApi.endpointDeleteLoan}/$loanId');
  }

}