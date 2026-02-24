import 'package:flutter/material.dart';

/// Responsive Layout Demo for StreetBuzz
/// Demonstrates the use of Rows, Columns, and Containers
/// to create adaptive layouts for different screen sizes
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // 📱 Get screen dimensions using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600;
    bool isLargeScreen = screenWidth > 900;

    debugPrint('📐 Screen Width: ${screenWidth.toStringAsFixed(1)}px');
    debugPrint(
      '📱 Device Type: ${isLargeScreen
          ? "Desktop/Large Tablet"
          : isTablet
          ? "Tablet"
          : "Phone"}',
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Responsive Layout Demo',
          style: TextStyle(fontSize: isTablet ? 24 : 18),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎯 HEADER SECTION - Full Width Container
              _buildHeaderSection(screenWidth, isTablet),

              const SizedBox(height: 20),

              // 📊 STATS ROW - Horizontal Layout
              _buildStatsRow(isTablet, isLargeScreen),

              const SizedBox(height: 20),

              // 🍔 MAIN CONTENT - Responsive Grid
              _buildMainContent(screenWidth, isTablet, isLargeScreen),

              const SizedBox(height: 20),

              // 👥 VENDOR PROFILES - Adaptive Layout
              _buildVendorProfiles(screenWidth, isTablet),

              const SizedBox(height: 20),

              // 📱 FOOTER - Column Layout
              _buildFooter(isTablet),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 Header Section - Using Container
  Widget _buildHeaderSection(double screenWidth, bool isTablet) {
    return Container(
      width: double.infinity,
      height: isTablet ? 180 : 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.orange.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'StreetBuzz Dashboard',
            style: TextStyle(
              fontSize: isTablet ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Responsive Layout Using Rows, Columns & Containers',
            style: TextStyle(
              fontSize: isTablet ? 18 : 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.devices,
                color: Colors.white,
                size: isTablet ? 24 : 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Adapts to all screen sizes',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 12,
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

  // 📊 Stats Row - Using Row Widget
  Widget _buildStatsRow(bool isTablet, bool isLargeScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.shopping_bag,
            title: 'Orders',
            value: '234',
            color: Colors.blue,
            isTablet: isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.restaurant,
            title: 'Vendors',
            value: '45',
            color: Colors.green,
            isTablet: isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.people,
            title: 'Customers',
            value: '1.2K',
            color: Colors.purple,
            isTablet: isTablet,
          ),
        ),
      ],
    );
  }

  // 📦 Individual Stat Card - Using Container
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isTablet ? 40 : 32),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 28 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: isTablet ? 14 : 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 🍔 Main Content - Responsive Grid Using Row & Column
  Widget _buildMainContent(
    double screenWidth,
    bool isTablet,
    bool isLargeScreen,
  ) {
    // Adaptive Layout: Stack vertically on phones, side-by-side on tablets
    if (isLargeScreen) {
      // 3-column layout for large screens
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildMenuCard('Popular Items', Colors.orange, isTablet),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMenuCard('Today\'s Special', Colors.red, isTablet),
          ),
          const SizedBox(width: 16),
          Expanded(child: _buildMenuCard('Trending', Colors.pink, isTablet)),
        ],
      );
    } else if (isTablet) {
      // 2-column layout for tablets
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMenuCard('Popular Items', Colors.orange, isTablet),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMenuCard('Today\'s Special', Colors.red, isTablet),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMenuCard('Trending', Colors.pink, isTablet),
        ],
      );
    } else {
      // 1-column layout for phones
      return Column(
        children: [
          _buildMenuCard('Popular Items', Colors.orange, isTablet),
          const SizedBox(height: 16),
          _buildMenuCard('Today\'s Special', Colors.red, isTablet),
          const SizedBox(height: 16),
          _buildMenuCard('Trending', Colors.pink, isTablet),
        ],
      );
    }
  }

  // 🎨 Menu Card - Using Container & Column
  Widget _buildMenuCard(String title, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Icon(Icons.arrow_forward, color: color, size: isTablet ? 24 : 20),
            ],
          ),
          const SizedBox(height: 12),
          _buildMenuItem('🍕 Pizza', '₹150', isTablet),
          const SizedBox(height: 8),
          _buildMenuItem('🍔 Burger', '₹120', isTablet),
          const SizedBox(height: 8),
          _buildMenuItem('🌮 Tacos', '₹100', isTablet),
        ],
      ),
    );
  }

  // 🍕 Menu Item - Using Row
  Widget _buildMenuItem(String name, String price, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 12 : 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  // 👥 Vendor Profiles - Adaptive Row/Column
  Widget _buildVendorProfiles(double screenWidth, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Vendors',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Responsive: Horizontal scroll on phones, grid on tablets
        isTablet
            ? Row(
                children: [
                  Expanded(
                    child: _buildVendorCard(
                      'Raj\'s Stall',
                      '⭐ 4.8',
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildVendorCard(
                      'Food Corner',
                      '⭐ 4.6',
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildVendorCard(
                      'Street Bites',
                      '⭐ 4.9',
                      Colors.orange,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildVendorCard('Raj\'s Stall', '⭐ 4.8', Colors.blue),
                  const SizedBox(height: 12),
                  _buildVendorCard('Food Corner', '⭐ 4.6', Colors.green),
                  const SizedBox(height: 12),
                  _buildVendorCard('Street Bites', '⭐ 4.9', Colors.orange),
                ],
              ),
      ],
    );
  }

  // 🏪 Vendor Card - Using Container, Row & Column
  Widget _buildVendorCard(String name, String rating, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: accentColor.withOpacity(0.2),
            child: Icon(Icons.store, color: accentColor, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rating,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: accentColor, size: 16),
        ],
      ),
    );
  }

  // 📱 Footer - Using Column
  Widget _buildFooter(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade700,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: isTablet ? 48 : 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Responsive Layout Complete!',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This layout adapts seamlessly to phones, tablets, and desktops',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
