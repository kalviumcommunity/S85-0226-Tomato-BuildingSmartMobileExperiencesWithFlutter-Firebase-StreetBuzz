import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'responsive_layout.dart';
import 'scrollable_views.dart';
import 'state_management_demo.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() => _ResponsiveHomeState();
}

class _ResponsiveHomeState extends State<ResponsiveHome> {
  bool isVendor = false;
  bool isConfirmed = false;
  int selectedIndex = 0;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 ResponsiveHome initialized');
  }

  Future<void> _logout() async {
    await _authService.logout();
  }

  void confirmOrder() {
    setState(() {
      isConfirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.purple.shade50,

      appBar: AppBar(
        title: const Text("🔥 Multi-Screen Navigation Demo"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.flash_on),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Flash Sale Activated ⚡")),
          );
        },
      ),

      body: Padding(
        padding: EdgeInsets.all(isTablet ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isVendor
                      ? [Colors.red.shade700, Colors.orange.shade400]
                      : [Colors.deepOrange, Colors.orange.shade300],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isVendor ? "🛒 Vendor Dashboard" : "🎉 Customer Mode",
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Switch Mode",
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: isVendor,
                        activeColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            isVendor = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ORDER CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black12,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order #102 - Paneer Roll",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isConfirmed ? "Status: Confirmed ✅" : "Status: Pending",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: confirmOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: const Text("Confirm Order"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Quick Features",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            /// FEATURE LIST
            Expanded(
              child: ListView(
                children: isVendor ? vendorCards() : customerCards(),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/orders');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// CUSTOMER CARDS
  List<Widget> customerCards() {
    return [
      featureCard(
        Icons.fastfood,
        "Order Food",
        "Browse stalls & order instantly",
      ),
      featureCard(Icons.timer, "Live Queue", "Track your order in real-time"),
      featureCard(Icons.star, "Top Vendors", "Find best-rated street food"),
      _buildResponsiveLayoutCard(),
      _buildScrollableViewsCard(),
      _buildStateManagementCard(),
    ];
  }

  /// VENDOR CARDS
  List<Widget> vendorCards() {
    return [
      featureCard(Icons.store, "Manage Orders", "Accept & prepare orders fast"),
      featureCard(Icons.dashboard, "Dashboard", "Monitor rush-hour sales"),
      featureCard(Icons.notifications, "Alerts", "Instant order notifications"),
      _buildScrollableViewsCard(),
      _buildStateManagementCard(),
    ];
  }

  /// FEATURE CARD
  Widget featureCard(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(icon, color: Colors.deepOrange),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$title Clicked 🚀")));
        },
      ),
    );
  }

  /// RESPONSIVE LAYOUT CARD
  Widget _buildResponsiveLayoutCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: const Icon(Icons.dashboard_customize, color: Colors.purple),
        ),
        title: const Text(
          'Responsive Layout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('View layout demo ➡️'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResponsiveLayout()),
          );
        },
      ),
    );
  }

  /// SCROLLABLE VIEWS CARD
  Widget _buildScrollableViewsCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.teal.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: const Icon(Icons.view_list, color: Colors.teal),
        ),
        title: const Text(
          'Scrollable Views',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('ListView & GridView demo ➡️'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          debugPrint('🎯 Navigating to Scrollable Views Demo');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScrollableViews()),
          );
        },
      ),
    );
  }

  /// STATE MANAGEMENT CARD
  Widget _buildStateManagementCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.sync, color: Colors.blue),
        ),
        title: const Text(
          'State Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('setState() demo ➡️'),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: () {
          debugPrint('🎯 Navigating to State Management Demo');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StateManagementDemo(),
            ),
          );
        },
      ),
    );
  }
}
