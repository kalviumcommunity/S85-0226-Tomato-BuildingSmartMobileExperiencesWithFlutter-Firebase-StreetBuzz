import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'responsive_layout.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() {
    debugPrint('🏗️ ResponsiveHome: Creating state instance');
    return _ResponsiveHomeState();
  }
}

class _ResponsiveHomeState extends State<ResponsiveHome> {
  bool isVendor = false;
feature/stateless-stateful-demo
  bool isConfirmed = false;

  int selectedIndex = 0;
 main
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 ResponsiveHome initialized');
  }

  Future<void> _logout() async {
    debugPrint('🔓 Logout initiated');
    await _authService.logout(); // StreamBuilder handles navigation
    debugPrint('✅ Logout completed');
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

    debugPrint('🔄 Rebuilding UI → Mode: ${isVendor ? "Vendor" : "Customer"}');

    return Scaffold(
 feature/stateless-stateful-demo
      backgroundColor: Colors.orange.shade50,

      backgroundColor: Colors.purple.shade50,

main
      appBar: AppBar(
        title: const Text("🔥 Multi-Screen Navigation Demo"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
feature/stateless-stateful-demo


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.flash_on),
        onPressed: () {
          debugPrint('⚡ Flash Sale Pressed');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Flash Sale Activated ⚡")),
          );
        },
      ),

main
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      fontSize: isTablet ? 30 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
feature/stateless-stateful-demo
                  const SizedBox(height: 8),
                  Text(
                    isVendor
                        ? "Manage orders faster during rush hours."
                        : "Order instantly & skip long queues.",
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isVendor ? "Vendor ON" : "Customer ON",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        activeColor: Colors.white,
                        value: isVendor,
                        onChanged: (value) {
                          setState(() {
                            isVendor = value;
                          });
                        },
                      ),
                    ],

                  const SizedBox(height: 12),
                  Switch(
                    value: isVendor,
                    activeColor: Colors.white,
                    onChanged: (value) {
                      debugPrint(
                        '🔄 Mode Changed → ${value ? "Vendor" : "Customer"}',
                      );
                      setState(() {
                        isVendor = value;
                      });
                    },
main
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

feature/stateless-stateful-demo
            // Reactive Order Card
            Container(
              margin: const EdgeInsets.only(bottom: 20),
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isConfirmed ? "Status: Confirmed ✅" : "Status: Pending",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    onPressed: confirmOrder,
                    child: const Text("Confirm Order"),
                  ),
                ],
              ),
            ),

            Text(

            const Text(
 main
              "Quick Features",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Expanded(
feature/stateless-stateful-demo
              child: LayoutBuilder(
                builder: (context, constraints) {
                  List<Widget> cards =
                      isVendor ? vendorCards() : customerCards();

                  if (isTablet) {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: 1.3,
                      children: cards,
                    );
                  }

                  return ListView.separated(
                    itemCount: cards.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) => cards[index],
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: isTablet ? 70 : 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  isVendor ? "Manage Orders →" : "Start Ordering →",
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

              child: ListView(
                children: isVendor ? vendorCards() : customerCards(),
              ),
            ),
          ],
        ),
      ),

      // 🔥 UPDATED NAVIGATION LOGIC
 main
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: (index) {
          debugPrint('🧭 Navigation tapped → index: $index');

          if (index == 0) {
            // Home - just update index
            setState(() {
              selectedIndex = 0;
            });
          } else if (index == 1) {
            // Orders Screen
            Navigator.pushNamed(
              context,
              '/orders',
              arguments: "Hello from StreetBuzz Home 🚀",
            );
          } else if (index == 2) {
            // Profile Screen
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood), label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  List<Widget> customerCards() {
    return [
feature/stateless-stateful-demo
      featureCard(Icons.fastfood, "Order Food",
          "Browse stalls & order instantly"),
      featureCard(Icons.timer, "Live Queue",
          "Track your order in real-time"),
      featureCard(Icons.star, "Top Vendors",
          "Find best-rated street food"),
      featureCard(Icons.payment, "Quick Pay",
          "UPI & digital checkout"),

      featureCard(
        Icons.fastfood,
        "Order Food",
        "Browse stalls & order instantly",
      ),
      featureCard(Icons.timer, "Live Queue", "Track your order in real-time"),
      featureCard(Icons.star, "Top Vendors", "Find best-rated street food"),
      // Navigate to Responsive Layout Demo
      _buildResponsiveLayoutCard(),
 main
    ];
  }

  List<Widget> vendorCards() {
    return [
 feature/stateless-stateful-demo
      featureCard(Icons.store, "Manage Orders",
          "Accept & prepare orders fast"),
      featureCard(Icons.dashboard, "Dashboard",
          "Monitor rush-hour sales"),
      featureCard(Icons.notifications, "Alerts",
          "Instant order notifications"),
      featureCard(Icons.analytics, "Analytics",
          "Track daily performance"),
    ];
  }

  Widget featureCard(
      IconData icon, String title, String subtitle) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(2, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon,
                color: Colors.deepOrange, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600),
                ),
              ],
            ),

      featureCard(Icons.store, "Manage Orders", "Accept & prepare orders fast"),
      featureCard(Icons.dashboard, "Dashboard", "Monitor rush-hour sales"),
      featureCard(Icons.notifications, "Alerts", "Instant order notifications"),
      // Navigate to Responsive Layout Demo
      _buildResponsiveLayoutCard(),
    ];
  }

  // Special card to navigate to Responsive Layout Demo
  Widget _buildResponsiveLayoutCard() {
    return GestureDetector(
      onTap: () {
        debugPrint('🎯 Navigating to Responsive Layout Demo');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResponsiveLayout()),
        );
      },
      child: Card(
        elevation: 4,
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
        ),
      ),
    );
  }

  Widget featureCard(IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        debugPrint('🎯 Feature Clicked → $title');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$title Clicked 🚀")));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon, color: Colors.deepOrange),
main
          ),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}