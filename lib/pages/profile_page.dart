import 'package:flutter/material.dart';

import 'package:authentication_supabase_flutter/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // get auth service
  final authService = AuthService();

  // logout button pressed
  void logout() async {
    await authService.signOut();
  }


  @override
  Widget build(BuildContext context) {
    // get user email
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome ${currentEmail!.toString()}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
