import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() {
    debugPrint('🏗️ ResponsiveHome: Creating state instance');
    return _ResponsiveHomeState();
  }
}

class _ResponsiveHomeState extends State<ResponsiveHome>
    with SingleTickerProviderStateMixin {
  bool isVendor = false;
  int selectedIndex = 0;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 ResponsiveHome: Widget initialized - Mode: Customer');
    debugPrint(
      '📊 Initial State - isVendor: $isVendor, selectedIndex: $selectedIndex',
    );
  }

  @override
  void dispose() {
    debugPrint('🗑️ ResponsiveHome: Widget disposed');
    super.dispose();
  }

  Future<void> _logout() async {
    debugPrint('🔓 Logout initiated by user');
    await _authService.logout(); // ✅ Let StreamBuilder handle navigation
    debugPrint('✅ Logout completed successfully');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;
    debugPrint(
      '🔄 ResponsiveHome: Widget rebuilding - Screen Width: ${screenWidth.toStringAsFixed(1)}px',
    );
    debugPrint(
      '📱 Device Type: ${isTablet ? "Tablet" : "Mobile"} - Current Mode: ${isVendor ? "Vendor" : "Customer"}',
    );

    return Scaffold(
      backgroundColor: Colors.purple.shade50,

      appBar: AppBar(
        title: const Text("🔥 Hot Reload Demo - StreetBuzz 🍔"),
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _logout();
            },
          ),
        ],
      ),

      // ✅ Floating Action Button (Interactive)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.flash_on),
        onPressed: () {
          debugPrint('⚡ Flash Sale button pressed!');
          debugPrint('💡 User triggered flash sale feature');
          debugPrint('🧪 HOT RELOAD DEMO - Testing Debug Console');
          debugPrint('📊 Current timestamp: ${DateTime.now()}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Flash Sale Activated ⚡ - Hot Reload Demo!"),
            ),
          );
        },
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Padding(
          key: ValueKey(isVendor),
          padding: EdgeInsets.all(isTablet ? 28 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Animated Banner
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
                      isVendor
                          ? "🛒 Vendor Dashboard 🔥"
                          : "🎉 Testing Hot Reload - Customer Mode! 😋",
                      style: TextStyle(
                        fontSize: isTablet ? 30 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Switch(
                      value: isVendor,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        debugPrint(
                          '🔄 Mode Switch Toggled: ${value ? "Vendor" : "Customer"} Mode',
                        );
                        debugPrint(
                          '📝 Previous State: ${isVendor ? "Vendor" : "Customer"} → New State: ${value ? "Vendor" : "Customer"}',
                        );
                        setState(() {
                          isVendor = value;
                        });
                        debugPrint(
                          '✅ State updated successfully - isVendor: $isVendor',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Quick Features",
                style: TextStyle(
                  fontSize: isTablet ? 24 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    List<Widget> cards = isVendor
                        ? vendorCards()
                        : customerCards();

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
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) => cards[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔥 Interactive Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: (index) {
          String tabName = index == 0
              ? "Home"
              : index == 1
              ? "Orders"
              : "Profile";
          debugPrint(
            '🧭 Navigation: Tab switched from index $selectedIndex to $index',
          );
          debugPrint('📍 User navigated to: $tabName tab');

          setState(() {
            selectedIndex = index;
          });
          debugPrint(
            '✅ Navigation state updated - selectedIndex: $selectedIndex',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                index == 0
                    ? "Home Selected"
                    : index == 1
                    ? "Orders Selected"
                    : "Profile Selected",
              ),
            ),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // 🔥 Customer Cards
  List<Widget> customerCards() {
    return [
      featureCard(
        Icons.fastfood,
        "Order Food",
        "Browse stalls & order instantly",
      ),
      featureCard(Icons.timer, "Live Queue", "Track your order in real-time"),
      featureCard(Icons.star, "Top Vendors", "Find best-rated street food"),
      featureCard(Icons.payment, "Quick Pay", "UPI & digital checkout"),
    ];
  }

  // 🔥 Vendor Cards
  List<Widget> vendorCards() {
    return [
      featureCard(Icons.store, "Manage Orders", "Accept & prepare orders fast"),
      featureCard(Icons.dashboard, "Dashboard", "Monitor rush-hour sales"),
      featureCard(Icons.notifications, "Alerts", "Instant order notifications"),
      featureCard(Icons.analytics, "Analytics", "Track daily performance"),
    ];
  }

  // 🔥 Interactive Feature Card
  Widget featureCard(IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        debugPrint('🎯 Feature Card Tapped: "$title"');
        debugPrint(
          '👤 User Action: Clicked on $title in ${isVendor ? "Vendor" : "Customer"} mode',
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$title Clicked 🚀")));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.orange.shade100,
              child: Icon(icon, color: Colors.deepOrange, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
