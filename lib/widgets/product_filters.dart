import 'package:flutter/material.dart';

class ProductFilters extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final String sortBy;
  final Function(String?) onSortChanged;

  const ProductFilters({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.sortBy,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Categories
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (_) => onCategorySelected(category),
                    backgroundColor: Colors.white10,
                    selectedColor: Theme.of(context).primaryColor,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Sort options
        Row(
          children: [
            const Text('Urutkan:', style: TextStyle(color: Colors.white70)),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: sortBy,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Nama')),
                DropdownMenuItem(value: 'rating', child: Text('Rating')),
                DropdownMenuItem(value: 'price', child: Text('Harga')),
              ],
              onChanged: onSortChanged,
            ),
          ],
        ),
      ],
    );
  }
}