 
import 'package:flutter/material.dart';
import 'package:frontend_app/data/models/Stock.dart';
import 'package:frontend_app/data/repositories/StockRepository.dart';

class StockProvider with ChangeNotifier{
  final StockRepository _stockRepository = StockRepository();

  List<Stock> _stocks = [];
  List<Stock> get stocks => _stocks;

  Future<void> getStockByUser(int idUser) async {
    _stocks = await _stockRepository.getStockByUser(idUser);
    notifyListeners();
  }

  Future<void> addStock(int idUser, Stock stock) async {
    await _stockRepository.addStock(idUser, stock);
    getStockByUser(idUser);
  }

  Future<void> updateStock(Stock stock) async {
    await _stockRepository.updateStock(stock);
    getStockByUser(stock.getFkUser().userId);
  }

  Future<void> deleteStock(int stockId, userId) async {
    await _stockRepository.deleteStock(stockId);
    getStockByUser(userId);
  }
}
 
 
