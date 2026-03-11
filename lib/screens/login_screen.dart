import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    try {
      debugPrint('Attempting login with email: ${_emailController.text.trim()}');
      
      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      debugPrint('Login successful - forcing navigation refresh');
      
      if (mounted) {
        _showSuccessSnackBar('Login successful!');
        
        // Force navigation refresh so AuthWrapper rebuilds
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/auth',
            (route) => false,
          );
        }
      }
    } catch (e) {
      debugPrint('Login error: $e');
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      
      setState(() {
        if (errorMessage.toLowerCase().contains('email')) {
          _emailError = errorMessage;
        } else if (errorMessage.toLowerCase().contains('password')) {
          _passwordError = errorMessage;
        } else {
          _showErrorSnackBar(errorMessage);
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Please enter your email first';
      });
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(_emailController.text.trim());
      if (mounted) {
        _showSuccessSnackBar('Password reset email sent! Check your inbox.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth > 420 ? 420.0 : screenWidth;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: 'Signing in...',
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFF6B35), // Deep Orange
                Color(0xFFFFB366), // Light Orange
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 60),
                                
                                // Logo and Title
                                Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.1),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.fastfood,
                                          size: 48,
                                          color: Color(0xFFFF6B35),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        'Welcome Back',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Sign in to continue to StreetBuzz',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 48),
                                
                                // Login Card
                                Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.08),
                                        blurRadius: 30,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      
                                      // Email Field
                                      AppTextField(
                                        label: 'Email Address',
                                        hint: 'Enter your email',
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          color: Color(0xFF999999),
                                        ),
                                        errorText: _emailError,
                                        onChanged: (_) {
                                          if (_emailError != null) {
                                            setState(() => _emailError = null);
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      
                                      // Password Field
                                      AppTextField(
                                        label: 'Password',
                                        hint: 'Enter your password',
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: Color(0xFF999999),
                                        ),
                                        onToggleVisibility: () {
                                          setState(() => _obscurePassword = !_obscurePassword);
                                        },
                                        errorText: _passwordError,
                                        onChanged: (_) {
                                          if (_passwordError != null) {
                                            setState(() => _passwordError = null);
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      
                                      // Forgot Password
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: _resetPassword,
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(0xFFFF6B35),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          ),
                                          child: const Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      
                                      // Login Button
                                      AppButton(
                                        text: 'Sign In',
                                        onPressed: _login,
                                        isLoading: _isLoading,
                                        isFullWidth: true,
                                      ),
                                      const SizedBox(height: 24),
                                      
                                      // Sign Up Link
                                      Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Don't have an account? ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF666666),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacementNamed(context, '/signup');
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: const Color(0xFFFF6B35),
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              ),
                                              child: const Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
