// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:authentication_supabase_flutter/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:authentication_supabase_flutter/injection_container.dart' as di;
import 'core/constants.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    await di.configureDependencies();
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

// Helper to access Supabase client instance easily
final supabase = Supabase.instance.client;