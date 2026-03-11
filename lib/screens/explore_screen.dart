import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../widgets/custom_sliver_delegate.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: CustomSliverChildDelegate(
                    childCount: 6,
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(context, index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, int index) {
    final categories = [
      {'name': 'Burgers', 'icon': Icons.lunch_dining, 'color': Color(0xFFFF6B35), 'count': 24},
      {'name': 'Pizza', 'icon': Icons.local_pizza, 'color': Color(0xFFE91E63), 'count': 18},
      {'name': 'Rolls', 'icon': Icons.breakfast_dining, 'color': Color(0xFF4CAF50), 'count': 32},
      {'name': 'Beverages', 'icon': Icons.local_cafe, 'color': Color(0xFF2196F3), 'count': 15},
      {'name': 'Desserts', 'icon': Icons.cake, 'color': Color(0xFFFF9800), 'count': 12},
      {'name': 'Combos', 'icon': Icons.fastfood, 'color': Color(0xFF9C27B0), 'count': 8},
    ];

    final category = categories[index];
    
    return SectionCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exploring ${category['name']}...'),
            backgroundColor: category['color'] as Color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (category['color'] as Color).withAlpha(26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['name'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category['count']} items available',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[400],
            size: 16,
          ),
        ],
      ),
    );
  }
}
