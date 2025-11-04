import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/modern_loading.dart';
import '../theme/app_theme.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.white.withOpacity(0.95),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Téléphones',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      const Color(0xFF6366F1).withOpacity(0.02),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8, top: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Theme.of(context).iconTheme.color,
                        size: 22,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                    ),
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.only(right: 20, top: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const SearchScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
                            ),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [AppTheme.cardShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.phone_iphone_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Trouvez votre téléphone idéal',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.onSurfaceColor,
                                  ),
                                ),
                                Text(
                                  'Reconditionnés et garantis',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 44,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = productProvider.categories[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == productProvider.categories.length - 1 ? 0 : 12,
                              ),
                              child: CategoryChip(
                                category: category,
                                isSelected: productProvider.selectedCategory == category,
                                onPressed: () => productProvider.setCategory(category),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: ModernLoading(size: 60),
                  ),
                );
              }
              
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childCount: productProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.products[index];
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutBack,
                      child: ProductCard(product: product),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}