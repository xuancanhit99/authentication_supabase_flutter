// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:authentication_supabase_flutter/core/error/failures.dart';
import 'package:authentication_supabase_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:authentication_supabase_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:authentication_supabase_flutter/core/error/exceptions.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  User? get currentUser => remoteDataSource.currentUser;

  @override
  Stream<User?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = remoteDataSource.currentUser;
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthCredentialsFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithPassword(
        email: email,
        password: password,
        data: data,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> recoverPassword(String email) async {
    try {
      await remoteDataSource.recoverPassword(email);
      return const Right(null); // Indicate success with Right(null) or Right(unit)
    } on AuthServerException catch (e) {
      return Left(AuthServerFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}