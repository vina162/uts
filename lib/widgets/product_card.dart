import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/animation_helpers.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;
  final int index;
  final bool animate;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.isFavorite,
    required this.index,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                            )
                          : Container(
                              width: 96,
                              height: 72,
                              color: Colors.white12,
                              child: const Icon(Icons.image, color: Colors.white24),
                            )),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onFavoriteToggle,
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
                              size: 20,
                            ),
                          ),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(8),
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
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: animate
          ? AnimationHelpers.staggeredListItem(
              card,
              index: index,
              animate: animate,
            )
          : card,
    );
  }
}