import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'Mobile Money';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Finaliser la commande',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Informations acheteur
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informations de livraison',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nom complet',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre nom';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Téléphone',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre téléphone';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Méthode de paiement
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Méthode de paiement',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...['Mobile Money', 'Orange Money', 'Airtel Money'].map(
                              (method) => RadioListTile<String>(
                                title: Text(method),
                                value: method,
                                groupValue: _paymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _paymentMethod = value!;
                                  });
                                },
                                activeColor: const Color(0xFF00D4AA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Résumé commande
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Résumé de la commande',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...cartProvider.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.product.name} x${item.quantity}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      '${(item.product.price * item.quantity).toStringAsFixed(0)} MGA',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${cartProvider.totalAmount.toStringAsFixed(0)} MGA',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00D4AA),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Bouton payer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _processPayment(cartProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D4AA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Payer ${cartProvider.totalAmount.toStringAsFixed(0)} MGA',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _processPayment(CartProvider cartProvider) async {
    if (_formKey.currentState!.validate()) {
      // Simulation du paiement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      // Créer la commande
      final order = Order(
        buyerName: _nameController.text,
        buyerEmail: _emailController.text,
        buyerPhone: _phoneController.text,
        items: cartProvider.items.map((item) => OrderItem(
          productId: item.product.id!,
          productName: item.product.name,
          productBrand: item.product.brand,
          productPrice: item.product.price,
          quantity: item.quantity,
        )).toList(),
        totalAmount: cartProvider.totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: _paymentMethod,
      );

      context.read<OrderProvider>().addOrder(order);
      cartProvider.clear();

      Navigator.pop(context); // Fermer le dialog
      Navigator.pop(context); // Retour au panier

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paiement réussi ! Commande confirmée.'),
          backgroundColor: Color(0xFF00D4AA),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}