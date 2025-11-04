import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../models/product.dart';
import '../models/order.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'vente_telephone.db';
  static const int _databaseVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Initialiser sqflite_ffi pour Linux/Desktop
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Table des produits
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        price REAL NOT NULL,
        image_url TEXT,
        description TEXT NOT NULL
      )
    ''');

    // Table des commandes
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        buyer_name TEXT NOT NULL,
        buyer_email TEXT NOT NULL,
        buyer_phone TEXT NOT NULL,
        total_amount REAL NOT NULL,
        order_date TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        status TEXT DEFAULT 'Payé'
      )
    ''');

    // Table des articles de commande
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        product_brand TEXT NOT NULL,
        product_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id)
      )
    ''');

    // Insérer des données de test
    await _insertSampleData(db);
  }

  static Future<void> _insertSampleData(Database db) async {
    await db.insert('products', {
      'name': 'iPhone 15 Pro',
      'brand': 'Apple',
      'price': 5400000,
      'image_url': '',
      'description': 'Le dernier iPhone avec puce A17 Pro'
    });

    await db.insert('products', {
      'name': 'Galaxy S24 Ultra',
      'brand': 'Samsung',
      'price': 5850000,
      'image_url': '',
      'description': 'Smartphone Samsung haut de gamme'
    });

    await db.insert('products', {
      'name': 'Pixel 8 Pro',
      'brand': 'Google',
      'price': 4500000,
      'image_url': '',
      'description': 'Smartphone Google avec IA avancée'
    });
  }

  // CRUD Produits
  static Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromJson(maps[i]));
  }

  static Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toJson());
  }

  static Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  static Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD Commandes
  static Future<int> insertOrder(Order order) async {
    final db = await database;
    
    // Insérer la commande
    int orderId = await db.insert('orders', {
      'buyer_name': order.buyerName,
      'buyer_email': order.buyerEmail,
      'buyer_phone': order.buyerPhone,
      'total_amount': order.totalAmount,
      'order_date': order.orderDate.toIso8601String(),
      'payment_method': order.paymentMethod,
      'status': order.status,
    });

    // Insérer les articles
    for (var item in order.items) {
      await db.insert('order_items', {
        'order_id': orderId,
        'product_id': item.productId,
        'product_name': item.productName,
        'product_brand': item.productBrand,
        'product_price': item.productPrice,
        'quantity': item.quantity,
      });
    }

    return orderId;
  }

  static Future<List<Order>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> orderMaps = await db.query('orders');
    
    List<Order> orders = [];
    for (var orderMap in orderMaps) {
      // Récupérer les articles de la commande
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderMap['id']],
      );

      List<OrderItem> items = itemMaps.map((itemMap) => OrderItem(
        productId: itemMap['product_id'],
        productName: itemMap['product_name'],
        productBrand: itemMap['product_brand'],
        productPrice: itemMap['product_price'],
        quantity: itemMap['quantity'],
      )).toList();

      orders.add(Order(
        id: orderMap['id'],
        buyerName: orderMap['buyer_name'],
        buyerEmail: orderMap['buyer_email'],
        buyerPhone: orderMap['buyer_phone'],
        items: items,
        totalAmount: orderMap['total_amount'],
        orderDate: DateTime.parse(orderMap['order_date']),
        paymentMethod: orderMap['payment_method'],
        status: orderMap['status'],
      ));
    }

    return orders;
  }
}