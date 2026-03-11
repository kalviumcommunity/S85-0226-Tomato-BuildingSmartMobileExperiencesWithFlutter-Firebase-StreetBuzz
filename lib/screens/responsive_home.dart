import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/app_card.dart';
import '../widgets/section_title.dart';
import '../widgets/like_button.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() => _ResponsiveHomeState();
}

class _ResponsiveHomeState extends State<ResponsiveHome>
    with SingleTickerProviderStateMixin {
  bool isVendor = false;
  bool isConfirmed = false;
  int selectedIndex = 0;

  late AnimationController _controller;

  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/splash');
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> confirmOrder() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to confirm orders'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Create a sample order in Firestore
      await _firestoreService.createOrder({
        'userId': currentUser.uid,
        'itemName': 'Paneer Roll',
        'totalAmount': 120,
        'status': 'confirmed',
        'customerEmail': currentUser.email,
      });

      setState(() {
        isConfirmed = true;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order confirmed successfully! 🎉'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Order confirmation error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error confirming order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "StreetBuzz",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),

      /// 🔥 Rotating FAB (Explicit Animation)
      floatingActionButton: RotationTransition(
        turns: _controller,
        child: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: const Icon(Icons.flash_on),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Flash Sale Activated ⚡")),
            );
          },
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(isTablet ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= HEADER =================
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isVendor
                      ? [Colors.deepOrange, Colors.redAccent]
                      : [Colors.orange, Colors.amber],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      isVendor
                          ? "🛒 Vendor Dashboard"
                          : "🎉 Customer Mode",
                      key: ValueKey(isVendor),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
            ),

            const SizedBox(height: 20),

            /// ================= ORDER CARD =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black12,
                    offset: Offset(0, 8),
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

                  /// 🔥 Fade Animation
                  AnimatedOpacity(
                    opacity: isConfirmed ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      isConfirmed
                          ? "Status: Confirmed ✅"
                          : "Status: Pending",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 12),

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
        onTap: () => Navigator.pushNamed(context, '/orders'),
      ),
      AppCard(
        title: "Live Queue",
        subtitle: "Track your order in real-time",
        icon: Icons.timer,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Live queue feature coming soon!')),
          );
        },
      ),
      AppCard(
        title: "Top Vendors",
        subtitle: "Find best-rated street food",
        icon: Icons.star,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Top vendors feature coming soon!')),
          );
        },
      ),
      const LikeButton(),
    ];
  }

  /// ================= VENDOR CARDS =================
  List<Widget> vendorCards() {
    return [
      AppCard(
        title: "Manage Orders",
        subtitle: "Accept & prepare orders fast",
        icon: Icons.store,
        onTap: () => Navigator.pushNamed(context, '/orders'),
      ),
      AppCard(
        title: "Dashboard",
        subtitle: "Monitor rush-hour sales",
        icon: Icons.dashboard,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vendor dashboard coming soon!')),
          );
        },
      ),
      AppCard(
        title: "Alerts",
        subtitle: "Instant order notifications",
        icon: Icons.notifications,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alerts feature coming soon!')),
          );
        },
      ),
      const LikeButton(),
    ];
  }
}