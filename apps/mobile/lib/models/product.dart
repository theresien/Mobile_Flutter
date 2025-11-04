class Product {
  final int? id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  String get formattedPrice => '${price.toStringAsFixed(0)} MGA';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'price': price,
      'image_url': imageUrl,
      'description': description,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
    );
  }
}