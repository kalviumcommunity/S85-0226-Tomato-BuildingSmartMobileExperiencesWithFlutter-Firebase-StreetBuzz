import 'package:flutter/material.dart';
import '../widgets/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF6B35), // Deep Orange
              Color(0xFFFFB366), // Light Orange
              Color(0xFFFFD4A2), // Even Lighter Orange
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final maxContentWidth = screenWidth > 420 ? 420.0 : screenWidth;
              
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top * 0.8),
                        
                        // Hero Section
                        AnimatedBuilder(
                          animation: _fadeController,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Column(
                                  children: [
                                    // Logo
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.15),
                                            blurRadius: 25,
                                            offset: const Offset(0, 15),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.fastfood,
                                        size: 60,
                                        color: Color(0xFFFF6B35),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 40),
                                    
                                    // App Name
                                    const Text(
                                      'StreetBuzz',
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                        height: 1.2,
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Tagline
                                    const Text(
                                      'Taste the Street.\nFeel the Buzz.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(255, 255, 255, 0.9),
                                        height: 1.4,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 60),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        
                        // Buttons Section
                        AnimatedBuilder(
                          animation: _slideController,
                          builder: (context, child) {
                            return SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  // Login Button
                                  AppButton(
                                    text: 'Sign In',
                                    onPressed: _navigateToLogin,
                                    isFullWidth: true,
                                    backgroundColor: Colors.white,
                                    textColor: const Color(0xFFFF6B35),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Create Account Button
                                  AppButton(
                                    text: 'Create Account',
                                    onPressed: _navigateToSignup,
                                    isFullWidth: true,
                                    backgroundColor: Colors.transparent,
                                    textColor: Colors.white,
                                    child: const Text(
                                      'Get Started',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Features
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildFeatureIcon(
                                        Icons.local_shipping_outlined,
                                        'Fast Delivery',
                                      ),
                                      _buildFeatureIcon(
                                        Icons.restaurant_outlined,
                                        'Best Food',
                                      ),
                                      _buildFeatureIcon(
                                        Icons.star_outline,
                                        'Top Rated',
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 40),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromRGBO(255, 255, 255, 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
