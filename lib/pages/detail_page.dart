import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';

class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          final isFavorite = favoritesProvider.isFavorite(product.id);
          
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Large image with hero and back button
                Stack(
                  children: [
                    Hero(
                      tag: product.id,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: product.imageAsset != null
                            ? Image.asset(
                                product.imageAsset!,
                                height: 260,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : (product.imageUrl != null
                                ? Image.network(
                                    product.imageUrl!,
                                    height: 260,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 260,
                                    width: double.infinity,
                                    color: Colors.white12,
                                    child: const Icon(Icons.image, color: Colors.white24, size: 48),
                                  )),
                      ),
                    ),
                    // Back button
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Material(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.category,
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              // Favorite button
                              IconButton(
                                onPressed: () => favoritesProvider.toggleFavorite(product.id),
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    key: ValueKey(isFavorite),
                                    color: isFavorite ? Colors.red : Colors.white70,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Certification info
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sertifikasi ${product.certification}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'No: ${product.certificationNumber}',
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                    Text(
                                      'Berlaku sampai: ${product.certificationExpiry.day}/${product.certificationExpiry.month}/${product.certificationExpiry.year}',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Description
                          const Text(
                            'Deskripsi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Ingredients
                          const Text(
                            'Bahan-bahan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: product.ingredients.map((ingredient) {
                              return Chip(
                                label: Text(ingredient),
                                backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                                labelStyle: const TextStyle(color: Colors.white70),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          // Rating and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${product.reviewCount})',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              Text(
                                'Rp ${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
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
}

