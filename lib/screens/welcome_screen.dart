import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // State variable to toggle button color/text
  bool isVendor = false;

  void toggleUserType() {
    setState(() {
      isVendor = !isVendor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], // Street food vibe color
      appBar: AppBar(
        title: const Text('StreetBuzz'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Image/Icon
            Icon(
              Icons.fastfood_rounded,
              size: 100,
              color: isVendor ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),

            // 2. Title Text
            Text(
              isVendor ? "Manage Orders Fast!" : "Skip the Queue!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 3. Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                isVendor
                    ? "Kitchen Display System for Vendors"
                    : "Order your favorite street food online.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            const SizedBox(height: 40),

            // 4. Interactive Button (State Change)
            ElevatedButton(
              onPressed: toggleUserType,
              style: ElevatedButton.styleFrom(
                backgroundColor: isVendor ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                isVendor ? "Switch to Customer" : "Switch to Vendor",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}