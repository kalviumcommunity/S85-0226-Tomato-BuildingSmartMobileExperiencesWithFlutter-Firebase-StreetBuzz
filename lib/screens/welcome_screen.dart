import 'package:flutter/material.dart';
import '../widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 48.0 : 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              
              // Logo and Title
              Column(
                children: [
                  Container(
                    width: isTablet ? 120 : 80,
                    height: isTablet ? 120 : 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(isTablet ? 30 : 20),
                    ),
                    child: Icon(
                      Icons.fastfood,
                      size: isTablet ? 60 : 40,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'StreetBuzz',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your favorite street food, delivered fast',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const Spacer(flex: 3),
              
              // Action Buttons
              Column(
                children: [
                  AppButton(
                    text: 'Sign In',
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    width: double.infinity,
                    height: isTablet ? 56 : 48,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Create Account',
                    onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                    backgroundColor: theme.colorScheme.surface,
                    textColor: theme.colorScheme.primary,
                    width: double.infinity,
                    height: isTablet ? 56 : 48,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Footer
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
