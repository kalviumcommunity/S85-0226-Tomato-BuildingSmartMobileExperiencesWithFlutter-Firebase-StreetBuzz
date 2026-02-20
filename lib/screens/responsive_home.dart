import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() => _ResponsiveHomeState();
}

class _ResponsiveHomeState extends State<ResponsiveHome>
    with SingleTickerProviderStateMixin {
  bool isVendor = false;
  int selectedIndex = 0;
  final _authService = AuthService();

  Future<void> _logout() async {
    await _authService.logout(); // ✅ Let StreamBuilder handle navigation
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,

      appBar: AppBar(
        title: const Text("StreetBuzz 🍔"),
        backgroundColor: Colors.deepOrange,
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
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.flash_on),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Flash Sale Activated ⚡"),
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
                          ? "Vendor Dashboard 🔥"
                          : "Customer Mode 😋",
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
                        setState(() {
                          isVendor = value;
                        });
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
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 14),
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
          setState(() {
            selectedIndex = index;
          });

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

  // 🔥 Customer Cards
  List<Widget> customerCards() {
    return [
      featureCard(Icons.fastfood, "Order Food",
          "Browse stalls & order instantly"),
      featureCard(Icons.timer, "Live Queue",
          "Track your order in real-time"),
      featureCard(Icons.star, "Top Vendors",
          "Find best-rated street food"),
      featureCard(Icons.payment, "Quick Pay",
          "UPI & digital checkout"),
    ];
  }

  // 🔥 Vendor Cards
  List<Widget> vendorCards() {
    return [
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

  // 🔥 Interactive Feature Card
  Widget featureCard(
      IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title Clicked 🚀")),
        );
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
                        fontWeight: FontWeight.bold),
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
            ),
          ],
        ),
      ),
    );
  }
}