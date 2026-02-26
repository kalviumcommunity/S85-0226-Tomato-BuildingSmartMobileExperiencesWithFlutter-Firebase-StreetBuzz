import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'responsive_layout.dart';
import 'scrollable_views.dart';
import 'state_management_demo.dart';

import '../widgets/custom_button.dart';
import '../widgets/app_card.dart';
import '../widgets/section_title.dart';
import '../widgets/like_button.dart';

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
        title: const Text("🔥 StreetBuzz Dashboard"),
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

            /// ================= HEADER =================
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
                        activeThumbColor: Colors.white,
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

            /// ================= ORDER CARD =================
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
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isConfirmed
                        ? "Status: Confirmed ✅"
                        : "Status: Pending",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),

                  /// Using CustomButton
                  CustomButton(
                    label: "Confirm Order",
                    onPressed: confirmOrder,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= SECTION TITLE =================
            const SectionTitle(title: "Quick Features"),

            /// ================= FEATURE LIST =================
            Expanded(
              child: ListView(
                children:
                    isVendor ? vendorCards() : customerCards(),
              ),
            ),
          ],
        ),
      ),

      /// ================= BOTTOM NAV =================
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

  /// ================= CUSTOMER CARDS =================
  List<Widget> customerCards() {
    return [
      AppCard(
        title: "Order Food",
        subtitle: "Browse stalls & order instantly",
        icon: Icons.fastfood,
      ),
      AppCard(
        title: "Live Queue",
        subtitle: "Track your order in real-time",
        icon: Icons.timer,
      ),
      AppCard(
        title: "Top Vendors",
        subtitle: "Find best-rated street food",
        icon: Icons.star,
      ),
      const LikeButton(),
      _buildResponsiveLayoutCard(),
      _buildScrollableViewsCard(),
      _buildStateManagementCard(),
    ];
  }

  /// ================= VENDOR CARDS =================
  List<Widget> vendorCards() {
    return [
      AppCard(
        title: "Manage Orders",
        subtitle: "Accept & prepare orders fast",
        icon: Icons.store,
      ),
      AppCard(
        title: "Dashboard",
        subtitle: "Monitor rush-hour sales",
        icon: Icons.dashboard,
      ),
      AppCard(
        title: "Alerts",
        subtitle: "Instant order notifications",
        icon: Icons.notifications,
      ),
      const LikeButton(),
      _buildScrollableViewsCard(),
      _buildStateManagementCard(),
    ];
  }

  /// ================= EXTRA NAV CARDS =================

  Widget _buildResponsiveLayoutCard() {
    return AppCard(
      title: "Responsive Layout",
      subtitle: "View layout demo ➡️",
      icon: Icons.dashboard_customize,
    );
  }

  Widget _buildScrollableViewsCard() {
    return AppCard(
      title: "Scrollable Views",
      subtitle: "ListView & GridView demo ➡️",
      icon: Icons.view_list,
    );
  }

  Widget _buildStateManagementCard() {
    return AppCard(
      title: "State Management",
      subtitle: "setState() demo ➡️",
      icon: Icons.sync,
    );
  }
}