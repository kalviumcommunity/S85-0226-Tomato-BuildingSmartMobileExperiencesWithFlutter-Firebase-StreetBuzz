import 'package:flutter/material.dart';

/// Scrollable Views Demo for StreetBuzz
/// Demonstrates the use of ListView and GridView widgets
/// for displaying dynamic, scrollable content efficiently
class ScrollableViews extends StatelessWidget {
  const ScrollableViews({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('📜 ScrollableViews: Building scrollable layout');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Scrollable Views Demo'),
        backgroundColor: Colors.deepOrange,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 Header Section
            _buildHeaderSection(),

            const SizedBox(height: 16),

            // 📜 LISTVIEW SECTION - Horizontal Scroll
            _buildSectionTitle('🍔 Featured Items - ListView'),
            _buildHorizontalListView(),

            const Divider(thickness: 2, height: 32),

            // 📜 LISTVIEW.BUILDER SECTION - Vertical Scroll
            _buildSectionTitle('👥 Active Vendors - ListView.builder'),
            _buildVerticalListView(),

            const Divider(thickness: 2, height: 32),

            // 🎨 GRIDVIEW SECTION - Grid Layout
            _buildSectionTitle('📊 Menu Categories - GridView'),
            _buildGridView(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 🎯 Header Section
  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.orange.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scrollable Views',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ListView & GridView Widgets Demo',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.view_list, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Efficient scrolling for dynamic content',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 📌 Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // 📜 HORIZONTAL LISTVIEW - Featured Items
  Widget _buildHorizontalListView() {
    debugPrint('🔄 Building horizontal ListView');

    final featuredItems = [
      {'name': '🍕 Pizza', 'price': '₹250', 'color': Colors.red},
      {'name': '🍔 Burger', 'price': '₹150', 'color': Colors.orange},
      {'name': '🌮 Tacos', 'price': '₹120', 'color': Colors.yellow},
      {'name': '🍜 Noodles', 'price': '₹180', 'color': Colors.green},
      {'name': '🍦 Ice Cream', 'price': '₹80', 'color': Colors.blue},
      {'name': '🥗 Salad', 'price': '₹100', 'color': Colors.purple},
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: featuredItems.length,
        itemBuilder: (context, index) {
          final item = featuredItems[index];
          return GestureDetector(
            onTap: () {
              debugPrint('🎯 Featured item clicked: ${item['name']}');
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (item['color'] as Color).withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (item['color'] as Color).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: (item['color'] as Color).withValues(alpha: 0.2),
                    child: Text(
                      item['name'].toString().split(' ')[0],
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['name'].toString().split(' ')[1],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['price'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 📜 VERTICAL LISTVIEW.BUILDER - Vendor List
  Widget _buildVerticalListView() {
    debugPrint('🔄 Building vertical ListView.builder');

    final vendors = List.generate(
      10,
      (index) => {
        'name': 'Vendor ${index + 1}',
        'rating': (4.0 + (index % 10) / 10).toStringAsFixed(1),
        'orders': '${(index + 1) * 50}+ orders',
        'status': index % 3 == 0 ? 'Closed' : 'Open',
        'color': Colors.primaries[index % Colors.primaries.length],
      },
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        final isOpen = vendor['status'] == 'Open';

        return GestureDetector(
          onTap: () {
            debugPrint('🎯 Vendor clicked: ${vendor['name']}');
            debugPrint(
              '📊 Rating: ${vendor['rating']}, Orders: ${vendor['orders']}',
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: (vendor['color'] as Color).withValues(alpha: 0.2),
                child: Icon(
                  Icons.store,
                  color: vendor['color'] as Color,
                  size: 30,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    vendor['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vendor['status'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      vendor['rating'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.shopping_bag,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vendor['orders'] as String,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: vendor['color'] as Color,
                size: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  // 🎨 GRIDVIEW.BUILDER - Menu Categories
  Widget _buildGridView() {
    debugPrint('🔄 Building GridView.builder');

    final categories = [
      {'name': 'Fast Food', 'icon': Icons.fastfood, 'count': '45'},
      {'name': 'Beverages', 'icon': Icons.local_drink, 'count': '28'},
      {'name': 'Desserts', 'icon': Icons.cake, 'count': '32'},
      {'name': 'Chinese', 'icon': Icons.ramen_dining, 'count': '38'},
      {'name': 'Indian', 'icon': Icons.dining, 'count': '52'},
      {'name': 'Snacks', 'icon': Icons.cookie, 'count': '41'},
      {'name': 'Healthy', 'icon': Icons.eco, 'count': '19'},
      {'name': 'Pizza', 'icon': Icons.local_pizza, 'count': '24'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = Colors.primaries[index % Colors.primaries.length];

          return GestureDetector(
            onTap: () {
              debugPrint('🎯 Category clicked: ${category['name']}');
              debugPrint('📊 Items available: ${category['count']}');
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.shade400, color.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${category['count']} items',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
