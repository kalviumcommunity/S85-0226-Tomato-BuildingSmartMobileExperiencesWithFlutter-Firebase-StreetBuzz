import 'package:flutter/material.dart';

/// Responsive Design Demo
/// Demonstrates the use of MediaQuery and LayoutBuilder
/// for creating adaptive layouts that work on all screen sizes
class ResponsiveDesignDemo extends StatelessWidget {
  const ResponsiveDesignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // 📱 Using MediaQuery to get screen dimensions
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design Demo'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: MediaQuery Example
              _buildSectionTitle('1. MediaQuery Example'),
              const SizedBox(height: 12),
              _buildMediaQueryDemo(screenWidth, screenHeight, orientation),

              const SizedBox(height: 30),

              // Section 2: LayoutBuilder Example
              _buildSectionTitle('2. LayoutBuilder Example'),
              const SizedBox(height: 12),
              _buildLayoutBuilderDemo(),

              const SizedBox(height: 30),

              // Section 3: Combined MediaQuery + LayoutBuilder
              _buildSectionTitle('3. Combined Approach'),
              const SizedBox(height: 12),
              _buildCombinedDemo(context),

              const SizedBox(height: 30),

              // Section 4: Practical Example - Product Grid
              _buildSectionTitle('4. Practical Example: Adaptive Grid'),
              const SizedBox(height: 12),
              _buildAdaptiveProductGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  // 📱 MediaQuery Demo
  Widget _buildMediaQueryDemo(
    double screenWidth,
    double screenHeight,
    Orientation orientation,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MediaQuery provides device metrics:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              'Screen Width',
              '${screenWidth.toStringAsFixed(1)}px',
            ),
            _buildInfoRow(
              'Screen Height',
              '${screenHeight.toStringAsFixed(1)}px',
            ),
            _buildInfoRow(
              'Orientation',
              orientation == Orientation.portrait ? 'Portrait' : 'Landscape',
            ),
            const SizedBox(height: 16),

            // Responsive Container using MediaQuery
            Container(
              width: screenWidth * 0.8, // 80% of screen width
              height: screenHeight * 0.1, // 10% of screen height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.teal.shade300],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Container: 80% width, 10% height',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📐 LayoutBuilder Demo
  Widget _buildLayoutBuilderDemo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LayoutBuilder provides layout constraints:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Using LayoutBuilder to build different layouts
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Mobile Layout - Vertical
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.phone_android,
                          size: 60,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '📱 Mobile Layout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Width: ${constraints.maxWidth.toStringAsFixed(0)}px',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Using Column layout for narrow screens',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Tablet/Desktop Layout - Horizontal
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.tablet,
                          size: 80,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📱 Tablet Layout',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Width: ${constraints.maxWidth.toStringAsFixed(0)}px',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Using Row layout for wide screens',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔄 Combined MediaQuery + LayoutBuilder Demo
  Widget _buildCombinedDemo(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Combining MediaQuery + LayoutBuilder:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                // Using both MediaQuery AND LayoutBuilder for maximum flexibility
                bool isMobile = screenWidth < 600;
                int itemsPerRow = isMobile ? 2 : 4;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isMobile
                            ? '📱 Mobile View (2 columns)'
                            : '💻 Tablet View (4 columns)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          itemsPerRow,
                          (index) => Container(
                            width:
                                (constraints.maxWidth -
                                    24 -
                                    (8 * (itemsPerRow - 1))) /
                                itemsPerRow,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Item ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🛍️ Practical Example: Adaptive Product Grid
  Widget _buildAdaptiveProductGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine number of columns based on available width
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth < 600) {
          // Mobile: 2 columns
          crossAxisCount = 2;
          childAspectRatio = 0.75;
        } else if (constraints.maxWidth < 900) {
          // Tablet: 3 columns
          crossAxisCount = 3;
          childAspectRatio = 0.8;
        } else {
          // Desktop: 4 columns
          crossAxisCount = 4;
          childAspectRatio = 0.85;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return _buildProductCard(index);
          },
        );
      },
    );
  }

  // 🍔 Product Card
  Widget _buildProductCard(int index) {
    final products = [
      {'name': 'Pizza', 'emoji': '🍕', 'price': '₹150', 'color': Colors.red},
      {
        'name': 'Burger',
        'emoji': '🍔',
        'price': '₹120',
        'color': Colors.orange,
      },
      {'name': 'Tacos', 'emoji': '🌮', 'price': '₹100', 'color': Colors.yellow},
      {'name': 'Sushi', 'emoji': '🍣', 'price': '₹200', 'color': Colors.pink},
      {'name': 'Ramen', 'emoji': '🍜', 'price': '₹130', 'color': Colors.green},
      {
        'name': 'Salad',
        'emoji': '🥗',
        'price': '₹90',
        'color': Colors.lightGreen,
      },
    ];

    final product = products[index % products.length];
    final productColor = product['color'] as MaterialColor;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [productColor.shade200, productColor.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              product['emoji'] as String,
              style: const TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 8),
            Text(
              product['name'] as String,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              product['price'] as String,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: productColor.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Info Row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
