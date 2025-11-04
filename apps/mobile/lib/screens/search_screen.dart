import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchResults = context.read<ProductProvider>().products;
  }

  void _performSearch(String query) {
    final productProvider = context.read<ProductProvider>();
    
    if (query.isEmpty) {
      setState(() {
        _searchResults = productProvider.products;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = productProvider.products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
               product.brand.toLowerCase().contains(query.toLowerCase()) ||
               product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Rechercher un téléphone...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color(0xFF999999)),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
          onChanged: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF666666)),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching && _searchController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF666666), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_searchResults.length} résultat(s) pour "${_searchController.text}"',
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchController.text.isEmpty 
                              ? Icons.search 
                              : Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Tapez pour rechercher'
                              : 'Aucun résultat trouvé',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 16,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: _searchResults[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}