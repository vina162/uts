import 'package:flutter/material.dart';

class HalalSearchBar extends StatelessWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final String hintText;

  const HalalSearchBar({
    super.key,
    required this.query,
    required this.onQueryChanged,
    required this.onClear,
    this.hintText = 'Cari produk halal...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: query)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: query.length),
                ),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: onQueryChanged,
            ),
          ),
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white70),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}