import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ventes réalisées',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune vente réalisée',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: ExpansionTile(
                  title: Text(
                    'Commande #${order.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        order.buyerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        '${order.formattedTotal} • ${order.paymentMethod}',
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Payé',
                      style: TextStyle(
                        color: Color(0xFF00D4AA),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Informations acheteur
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Informations acheteur',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Nom: ${order.buyerName}'),
                                Text('Email: ${order.buyerEmail}'),
                                Text('Téléphone: ${order.buyerPhone}'),
                                Text('Date: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Produits vendus
                          const Text(
                            'Produits vendus',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...order.items.map(
                            (item) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE5E5E5)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F8F8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.phone_android,
                                      size: 20,
                                      color: Color(0xFFCCCCCC),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '${item.productBrand} • Qté: ${item.quantity}',
                                          style: const TextStyle(
                                            color: Color(0xFF666666),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${(item.productPrice * item.quantity).toStringAsFixed(0)} MGA',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF00D4AA),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}