import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/animated_scale_button.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleButton(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            AppTheme.cardShadow,
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  gradient: AppTheme.surfaceGradient,
                ),
                child: product.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: _buildImage(product.imageUrl),
                      )
                    : Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.phone_iphone_rounded,
                            size: 40,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 18,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.brand.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: const Color(0xFF0F172A),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.formattedPrice,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Prix reconditionné',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              cartProvider.addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${product.name} ajouté',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppTheme.successColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    // Vérifier si c'est un fichier local ou une URL
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.phone_iphone_rounded,
            size: 40,
            color: Color(0xFF6366F1),
          ),
        ),
      );
    } else {
      // Image locale
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.phone_iphone_rounded,
            size: 40,
            color: Color(0xFF6366F1),
          ),
        );
      }
    }
  }
}