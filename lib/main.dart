import 'package:authentication_supabase_flutter/pages/login_page.dart';
import 'package:authentication_supabase_flutter/pages/profile_page.dart';
import 'package:authentication_supabase_flutter/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:authentication_supabase_flutter/auth/auth_gate.dart';

import 'core/constants.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error initializing app: $e');
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Error initializing app: $e'))),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthGate(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
