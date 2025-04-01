import 'package:flutter/material.dart';

import 'package:authentication_supabase_flutter/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // get auth service
  final authService = AuthService();

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // sign up button pressed
  void signUp() async {
    // Store context in local variable
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);


    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validate empty fields
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate email format
    if (!email.contains('@')) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate password length
    if (password.length < 6) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await authService.signUpWithEmailAndPassword(email, password);

      if (mounted) {
        // Sign out immediately after successful registration
        await authService.signOut();

        navigator.pop(); // Remove loading indicator

        // Show success message
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to login page
        navigator.pop(); // Return to login page
      }
    } catch (e) {
      if (mounted) {
        navigator.pop(); // Remove loading indicator
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Page')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 100),
          const Text(
            'Register',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // email
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // password
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),

          // confirm password
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),

          // login button
          ElevatedButton(onPressed: signUp, child: const Text('Sign Up')),
        ],
      ),
    );
  }
}
