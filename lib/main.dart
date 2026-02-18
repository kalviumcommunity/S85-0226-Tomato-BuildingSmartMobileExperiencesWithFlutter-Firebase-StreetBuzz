import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart'; // Import your new screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreetBuzz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(), // Set WelcomeScreen as the home
      debugShowCheckedModeBanner: false, // Removes the 'Debug' banner
    );
  }
}