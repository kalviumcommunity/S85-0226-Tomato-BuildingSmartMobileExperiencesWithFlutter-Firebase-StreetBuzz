import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final AuthService _auth = AuthService();

  bool _loading = false;
  bool _obscure = true;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await _auth.createUserWithEmailAndPassword(
        _email.text.trim(),
        _password.text.trim(),
        _name.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isTablet = w > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 40 : 20),
          child: Container(
            width: isTablet ? 450 : double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Text(
                    "Join StreetBuzz",
                    style: Theme.of(context).textTheme.headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Enter your name" : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? "Enter email" : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() => _obscure = !_obscure);
                        },
                      ),
                    ),
                    validator: (v) =>
                        v!.length < 6 ? "Min 6 characters" : null,
                  ),

                  const SizedBox(height: 35),

                  _loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _signup,
                            child: const Text("Create Account"),
                          ),
                        ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text("Already have account? Sign In"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}