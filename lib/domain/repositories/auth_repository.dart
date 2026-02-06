import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    String? name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<void> logout();

  bool isLoggedIn();
}
