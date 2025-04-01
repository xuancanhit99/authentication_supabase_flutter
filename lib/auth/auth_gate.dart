/*

AUTH GATE- This will continuously listen for auth state changes

--------------------------------------------------------------------------------

unauthenticated -> Login Page
authenticated -> Profile Page

 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:authentication_supabase_flutter/pages/login_page.dart';
import 'package:authentication_supabase_flutter/pages/profile_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen for auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          // User is authenticated
          return const ProfilePage();
        } else {
          // User is not authenticated
          return const LoginPage();
        }

      },
    );
  }
}

