import 'package:flutter/material.dart';

class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stateless vs Stateful Demo"),
        backgroundColor: Colors.deepOrange,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DemoHeader(),
            SizedBox(height: 40),
            CounterSection(),
          ],
        ),
      ),
    );
  }
}

// ================= STATeless Widget =================
class DemoHeader extends StatelessWidget {
  const DemoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Interactive Counter App",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
    );
  }
}

// ================= STATEful Widget =================
class CounterSection extends StatefulWidget {
  const CounterSection({super.key});

  @override
  State<CounterSection> createState() => _CounterSectionState();
}

class _CounterSectionState extends State<CounterSection> {
  int count = 0;
  bool isDarkMode = false;

  void increment() {
    setState(() {
      count++;
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            "Count: $count",
            style: TextStyle(
              fontSize: 22,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: increment,
            child: const Text("Increase Counter"),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: toggleTheme,
            child: Text(
              isDarkMode ? "Switch to Light Mode"
                         : "Switch to Dark Mode",
            ),
          ),
        ],
      ),
    );
  }
}