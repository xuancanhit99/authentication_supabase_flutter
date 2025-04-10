// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart'; // Can expose Supabase User directly or map
import 'package:fpdart/fpdart.dart'; // For Either
import 'package:authentication_supabase_flutter/core/error/failures.dart'; // Your custom Failure class
import 'package:authentication_supabase_flutter/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {

  User? get currentUser;

  // Stream to notify about auth changes (login, logout)
  Stream<User?> get authStateChanges; // Exposing Supabase User directly for simplicity here

  // Get current user if logged in
  Future<Either<Failure, User?>> getCurrentUser();

  // Sign in with email and password
  Future<Either<Failure, User>> signInWithPassword({
    required String email,
    required String password,
  });

  // Sign up with email and password
  Future<Either<Failure, User>> signUpWithPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data, // Optional: for additional user metadata
  });

  // Recover password
  Future<Either<Failure, void>> recoverPassword(String email);

  // Sign out
  Future<Either<Failure, void>> signOut();
}