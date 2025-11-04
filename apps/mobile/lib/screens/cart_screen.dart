import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        title: Text(
          'Mon panier',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.onSurfaceColor,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Votre panier est vide',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des produits pour commencer',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [AppTheme.cardShadow],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: AppTheme.surfaceGradient,
                              ),
                              child: const Icon(
                                Icons.phone_iphone_rounded,
                                color: AppTheme.primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppTheme.onSurfaceColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.product.formattedPrice,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_rounded, size: 20),
                                    color: AppTheme.primaryColor,
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        item.product.id!,
                                        item.quantity - 1,
                                      );
                                    },
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      '${item.quantity}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: AppTheme.onSurfaceColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_rounded, size: 20),
                                    color: AppTheme.primaryColor,
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        item.product.id!,
                                        item.quantity + 1,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [AppTheme.elevatedShadow],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurfaceColor,
                          ),
                        ),
                        Text(
                          '${cartProvider.totalAmount.toStringAsFixed(0)} MGA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Commander',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}