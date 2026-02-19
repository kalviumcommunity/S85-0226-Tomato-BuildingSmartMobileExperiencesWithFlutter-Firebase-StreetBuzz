import 'package:flutter/material.dart';

class ResponsiveHome extends StatefulWidget {
  const ResponsiveHome({super.key});

  @override
  State<ResponsiveHome> createState() => _ResponsiveHomeState();
}

class _ResponsiveHomeState extends State<ResponsiveHome> {
  bool isVendor = false;

  @override
  Widget build(BuildContext context) {
    // ✅ MediaQuery for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.orange.shade50,

      // ✅ AppBar Header
      appBar: AppBar(
        title: const Text("StreetBuzz 🍔"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        elevation: 3,
      ),

      body: Padding(
        padding: EdgeInsets.all(isTablet ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Banner + Toggle Switch
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

                  // ✅ Toggle Button
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
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ✅ Section Title
            Text(
              "Quick Features",
              style: TextStyle(
                fontSize: isTablet ? 24 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ✅ Main Responsive Layout
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  List<Widget> cards = isVendor
                      ? vendorCards()
                      : customerCards();

                  // ✅ Tablet → Grid Layout
                  if (isTablet) {
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: 1.3,
                      children: cards,
                    );
                  }

                  // ✅ Phone → List Layout
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

            // ✅ Footer Button
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

      // ✅ Bottom Navigation Bar (Professional Touch)
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // ✅ Customer Features
  List<Widget> customerCards() {
    return [
      featureCard(
        Icons.fastfood,
        "Order Food",
        "Browse stalls & order instantly",
      ),
      featureCard(
        Icons.timer,
        "Live Queue",
        "Track your order in real-time",
      ),
      featureCard(
        Icons.star,
        "Top Vendors",
        "Find best-rated street food",
      ),
      featureCard(
        Icons.payment,
        "Quick Pay",
        "UPI & digital checkout",
      ),
    ];
  }

  // ✅ Vendor Features
  List<Widget> vendorCards() {
    return [
      featureCard(
        Icons.store,
        "Manage Orders",
        "Accept & prepare orders fast",
      ),
      featureCard(
        Icons.dashboard,
        "Dashboard",
        "Monitor rush-hour sales",
      ),
      featureCard(
        Icons.notifications,
        "Alerts",
        "Instant order notifications",
      ),
      featureCard(
        Icons.analytics,
        "Analytics",
        "Track daily performance",
      ),
    ];
  }

  // ✅ Feature Card Widget
  Widget featureCard(IconData icon, String title, String subtitle) {
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
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.orange.shade100,
            child: Icon(
              icon,
              color: Colors.deepOrange,
              size: 28,
            ),
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
