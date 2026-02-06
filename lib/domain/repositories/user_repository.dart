import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getProfile();

  Future<Either<Failure, User>> updateProfile({
    required int id,
    String? name,
    String? email,
    String? password,
  });

  Future<Either<Failure, void>> deleteAccount(int id);
}
