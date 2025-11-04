import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';
  bool _initialized = false;

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
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      // Mock data pour le développement - seulement si pas encore initialisé
      if (!_initialized) {
        _products = _getMockProducts();
        _initialized = true;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 201) {
        await fetchProducts();
        return;
      }
    } catch (e) {
      // Fallback: ajouter localement
      final newId = _products.isEmpty ? 1 : _products.map((p) => p.id!).reduce((a, b) => a > b ? a : b) + 1;
      _products.add(Product(
        id: newId,
        name: product.name,
        brand: product.brand,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
      ));
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/products/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchProducts();
        return;
      }
    } catch (e) {
      // Fallback: modifier localement
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/api/products/$id'),
      );
      if (response.statusCode == 200) {
        await fetchProducts();
        return;
      }
    } catch (e) {
      // Fallback: supprimer localement
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    }
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        name: 'iPhone 15 Pro',
        brand: 'Apple',
        price: 5400000,
        imageUrl: 'https://via.placeholder.com/300x400',
        description: 'Le dernier iPhone avec puce A17 Pro',
      ),
      Product(
        id: 2,
        name: 'Galaxy S24 Ultra',
        brand: 'Samsung',
        price: 5850000,
        imageUrl: 'https://via.placeholder.com/300x400',
        description: 'Smartphone Samsung haut de gamme',
      ),
      Product(
        id: 3,
        name: 'Pixel 8 Pro',
        brand: 'Google',
        price: 4500000,
        imageUrl: 'https://via.placeholder.com/300x400',
        description: 'Smartphone Google avec IA avancée',
      ),
    ];
  }
}