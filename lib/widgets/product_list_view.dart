import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../utils/animation_helpers.dart';
import '../widgets/product_card.dart';
import '../pages/detail_page.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final bool showAnimation;
  final ScrollController? scrollController;

  const ProductListView({
    super.key,
    required this.products,
    this.showAnimation = true,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada produk ditemukan',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, _) {
            return ProductCard(
              product: product,
              index: index,
              animate: showAnimation,
              isFavorite: favoritesProvider.isFavorite(product.id),
              onFavoriteToggle: () => favoritesProvider.toggleFavorite(product.id),
              onTap: () => Navigator.push(
                context,
                AnimationHelpers.createRoute(DetailPage(product: product)),
              ),
            );
          },
        );
      },
    );
  }
}