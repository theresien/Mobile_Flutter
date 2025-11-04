class Order {
  final int? id;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final String status;

  Order({
    this.id,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.paymentMethod,
    this.status = 'Payé',
  });

  String get formattedTotal => '${totalAmount.toStringAsFixed(0)} MGA';
}

class OrderItem {
  final int productId;
  final String productName;
  final String productBrand;
  final double productPrice;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productBrand,
    required this.productPrice,
    required this.quantity,
  });
}