import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/admin_screen.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Vente Téléphone',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const AdminScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            selectedItemColor: const Color(0xFF6366F1),
            unselectedItemColor: const Color(0xFF64748B),
            selectedFontSize: 12,
            unselectedFontSize: 11,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.home_outlined, size: 22),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.home_rounded, size: 22),
                ),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.shopping_bag_outlined, size: 22),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, size: 22),
                ),
                label: 'Panier',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.add_circle_outline, size: 22),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_circle_rounded, size: 22),
                ),
                label: 'Ajouter',
              ),
            ],
          ),
        ),
      ),
    );
  }
}