import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/database_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  Future<void> loadOrders() async {
    try {
      _orders = await DatabaseService.getOrders();
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement des commandes: $e');
    }
  }

  Future<void> addOrder(Order order) async {
    try {
      await DatabaseService.insertOrder(order);
      await loadOrders();
    } catch (e) {
      print('Erreur lors de l\'ajout de la commande: $e');
    }
  }

  List<OrderItem> get soldProducts {
    List<OrderItem> sold = [];
    for (var order in _orders) {
      sold.addAll(order.items);
    }
    return sold;
  }
}