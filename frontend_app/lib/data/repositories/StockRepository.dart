import 'package:frontend_app/data/EndpointsApi.dart';
import 'package:frontend_app/data/models/Stock.dart';
import 'package:frontend_app/data/services/ApiService.dart';

class StockRepository {
  final ApiService _apiService = ApiService();

  Future<List<Stock>> getStockByUser(int idUser) async {
    try {
      final response = await _apiService.dio.get('${EndpointsApi.endpointGetStockByUser}/$idUser');
      return (response.data as List)
          .map((json) => Stock.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener el stock");
    }
  }

  Future<void> addStock(int idUser, Stock stock) async {
    await _apiService.dio.post(EndpointsApi.endpointAddStock, data: stock.toJson());
  }

  Future<void> updateStock(Stock stock) async {
    await _apiService.dio.put('${EndpointsApi.endpointEditStock}/${stock.stockId}', data: stock.toJson());

  }

  Future<void> deleteStock(int stockId) async {
    await _apiService.dio.delete('${EndpointsApi.endpointDeleteStock}/$stockId');
  }
}