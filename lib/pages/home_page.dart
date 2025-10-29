import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/favorites_provider.dart';
import '../services/auth_service.dart';
import '../widgets/halal_search_bar.dart';
import 'detail_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _categories = [
    'Semua',
    'Makanan Instant',
    'Roti & Bakery',
    'Minuman',
    'Bumbu Dapur',
    'Kosmetik',
    'Snack',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
    bool isFavorite,
    Function(String) toggleFavorite,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(product: product)),
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Hero(
                tag: product.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.imageAsset != null
                      ? Image.asset(
                          product.imageAsset!,
                          width: 96,
                          height: 72,
                          fit: BoxFit.cover,
                        )
                      : (product.imageUrl != null
                          ? Image.network(
                              product.imageUrl!,
                              width: 96,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 72),
                            )
                          : const Icon(Icons.image, size: 72)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () => toggleFavorite(product.id),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HalalFinder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Semua Produk'),
            Tab(text: 'Favorit'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HalalSearchBar(
              query: productProvider.searchQuery,
              onQueryChanged: productProvider.setSearchQuery,
              onClear: () => productProvider.setSearchQuery(''),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: category == productProvider.selectedCategory,
                    onSelected: (selected) {
                      if (selected) productProvider.setCategory(category);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Products tab
                productProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productProvider.error != null
                        ? Center(child: Text('Error: ${productProvider.error}'))
                        : products.isEmpty
                            ? const Center(child: Text('No products found'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return _buildProductCard(
                                    context,
                                    product,
                                    favoritesProvider.isFavorite(product.id),
                                    favoritesProvider.toggleFavorite,
                                  );
                                },
                              ),
                // Favorites tab
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoritesProvider.favorites.length,
                  itemBuilder: (context, index) {
                    final product = favoritesProvider.favorites[index];
                    return _buildProductCard(
                      context,
                      product,
                      true,
                      favoritesProvider.toggleFavorite,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}