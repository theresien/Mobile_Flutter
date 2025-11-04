import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  bool _initialized = false;

  ProductProvider() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (!_initialized) {
      await fetchProducts();
      _initialized = true;
    }
  }

  List<Product> get products {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products.where((p) => p.brand == _selectedCategory).toList();
  }
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  final List<String> categories = ['All', 'Apple', 'Samsung', 'Google', 'OnePlus', 'Xiaomi', 'Huawei'];

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await DatabaseService.getProducts();
    } catch (e) {
      print('Erreur lors du chargement des produits: $e');
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    try {
      await DatabaseService.insertProduct(product);
      await fetchProducts();
    } catch (e) {
      print('Erreur lors de l\'ajout du produit: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await DatabaseService.updateProduct(product);
      await fetchProducts();
    } catch (e) {
      print('Erreur lors de la modification du produit: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await DatabaseService.deleteProduct(id);
      await fetchProducts();
    } catch (e) {
      print('Erreur lors de la suppression du produit: $e');
    }
  }


}